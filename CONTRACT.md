# Configuration

## How to get the auth_hash

To wield the power of the `auth_hash`, you must follow a number of configuration steps. First set up some routes in your application.

### Routes

In your `config/routes.rb` be sure to add this:

```ruby
devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
```

This will tell Devise to create the following routes for `Users`

```
user_omniauth_authorize GET|POST /users/auth/:provider(.:format)        users/omniauth_callbacks#passthru {:provider=>/nyulibraries/}

 user_omniauth_callback GET|POST /users/auth/:action/callback(.:format) users/omniauth_callbacks#(?-mix:nyulibraries)
```

Look familiar? This is the callback URL you added to __NYU Libraries central login system__ as part of the [getting started](https://github.com/NYULibraries/login#adding-your-application-as-a-client)!


Now that you have the proper route that NYU Libraries central login system can send the `auth_hash` to, you must now create a controller for that route.

### Controllers

In `app/controllers`, create a controller to reflect your new route, complete with a namespace. This will be `app/controllers/users/omniauth_callback.rb`.

```ruby
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def nyulibraries
    @user = User.find_or_create_for_omniauth_auth_hash(request.env["omniauth.auth"])
    sign_in_and_redirect @user
  end
end
```

Did you catch that? The `request.env["omniauth.auth"]` is the formal way to retrieve the `auth_hash`. Once you've retrieved it, you can use it sign in the user. The method `User.find_or_create_for_omniauth_auth_hash()` doesn't yet exist, but for illustrative purposes it's goal is spelled out here.

You can set up more advanced controls, like flash messages or persistence options, as well as the ability to sign up.


### User Model extra Methods

Recall the `User.find_or_create_for_omniauth_auth_hash()`. This illustrative method is implemented in the `User` model. Example configurations are as follows:

```ruby
  def self.find_or_create_for_omniauth_auth_hash(auth_hash)
    User.find_or_create_by(uid: auth_data.uid)
  end
```

```ruby
  # Create by UID and provider
  def self.find_or_create_for_omniauth_auth_hash(auth_hash)
    User.find_or_create_by(uid: auth_data.uid, provider: auth_data.provider)
  end
```

```ruby
  # Create by UID and Email
  def self.find_or_create_for_omniauth_auth_hash(auth_hash)
    User.find_or_create_by(uid: auth_data.uid, email: auth_data.info.email)
  end
```

All we end up doing is using a simple `User.find_or_create_by()` method that exists in the `User` model. Now we have made a user (or found one), and in the `callback_controller.rb` we [login using this user](https://github.com/NYULibraries/login/GETTING_STARTED.md#Controllers).

### Models

You've heard a lot of this `User` model. Here is the formal declaration of what the `User` model should be. The `User` model is a `Devise` model (assuming you successfully implemented [Devise](https://github.com/plataformatec/devise)). In this example we will give the `User` a `uid` and `provider` field so that we can `find_or_create_by()` both parameters.

```ruby
rails g migration AddFieldToUsers uid provider
# rails g migration AddUidToUsers uid provider email ...
rake db:migrate
```

After that, you must mark your Model `Omniauthable`.

```ruby
class User < ActiveRecord::Base
  #...
  devise :omniauthable
  #...
  # Create by UID and provider
  def self.find_or_create_for_omniauth_auth_hash(auth_hash)
    User.find_or_create_by(uid: auth_data.uid, provider: auth_data.provider)
  end
end
```

### Views Helpers

Available to you are new fancy view helpers

```ruby
<%= link_to "Sign in with NYU Login", user_omniauth_authorize_path(:nyulibraries) %>
```
### How to sign out

If you want to add links to signing out, simply add this to your Routes:

```ruby
devise_scope :user do
  get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
end
```
You'll have to make sure your `User` model does not have the `devise :database_authenticatable` module loaded or else there will be a clash.

Then add the sign out link by using:

```ruby
<%= link_to "Sign out", destroy_user_session_path %>
```

And that's it! You can now login with NYU Libraries central login system in the simplest way possible.


# NYULibraries Login API
## Access Token
The API is pretty straightforward. However you might have to make some changes to existing classes, for example you will have to add a column for the access_token in your `User` model.

```
rails g migration AddLoginAccessTokenToUsers nyu_access_token:string
```

This token allows you to interact with login's API. You will want to store this token when getting information from NYU Libraries central login system.


Alter the `User` model to include a method like this:

```ruby
  def self.find_or_create_for_omniauth(auth_hash)
    @user = User.find_or_create_by(uid: auth_data.uid, email: auth_data.info.email).tap do |user|
      # We're updating the access_token
      # auth_hash is the OmniAuth Auth Hash
      user.access_token = auth_data.credentials.token
      user.save!
    end
  end
```

## Exploring the API

Once you have your access token, you can use the following methods to interact with the API.

```ruby
  # Create a client connection to NYU Libraries central login system
  # APP_ID and APP_SECRET are the unique Application Id and Application Secret keys you got
  # when you added your application as a client in NYU Libraries central login system
  # LOGIN_URL is the URL you use for your instance of NYU Libraries central login system
  @client = OAuth2::Client.new(APP_ID, APP_SECRET, LOGIN_URL)
  # Create the AccessToken by passing in the client and the current users access_token, as we
  # defined in the first step.
  @token = OAuth2::AccessToken.new(@client, current_user.access_token) if current_user
  # This parses the JSON string that NYU Libraries central login system returns.
  @json = @token.get("api/v1/#{params[:api]}").parsed
```

The `@json` will give you a hash that contains all the information you need on the `User`. For example `@json['identities']` will give you any identities attached to that `User` from NYU Libraries central login system.

## Putting it in a helper

Accessing the API may happen quite a lot for your application. You can use these helper methods to DRY up your API
calls.

```ruby
def nyulibraries_oauth_client
  @client ||= OAuth2::Client.new(APP_ID, APP_SECRET, LOGIN_URL)
end

def nyulibraries_oauth_token
  @token ||= OAuth2::AccessToken.new(nyulibraries_oauth_client, current_user.access_token) if current_user
end

def nyulibraries_json
  @json ||= nyulibraries_oauth_token.get("api/v1/#{params[:api]}").parsed
end
```

## Testing and Development
