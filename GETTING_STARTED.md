# Getting Started

__NYU Libraries central login system__ acts as an authentication method by being an OAuth2 provider. __NYU Libraries central login system allows automatic authentication, thus not all client applications will be authenticatable by NYU Libraries central login system, only admins can allow clients access__. To use __NYU Libraries central login system__ as your OAuth2 provider, you must first register your application as a client for [Login](https://github.com/NYULibraries/login). This will tell __Login__ where the client applications callback URL is.

To do so, you must have access to an Admin account in __Login__.

## Adding your application as a client

  1. Login to __NYU Libraries central login system__ as an admin.
  2. Visit the applications page (located at __/oauth/applications__).
  3. Click __Add new application__
  4. Enter your client Application's title and it's callback URL (it will probably be '/users/auth/nyulibraries/callback').
  5. Click submit.

Congrats, your application is now a client. You will be given a unique __Application Id__ and __Application Secret__. These two keys are very important, and they will be used by your client app to communicate with __Login__ via an API.

## Integrating

Now that your application is a client, now is a good time to find out what that means. Your application can now ask __NYU Libraries central login system__ to handle any sort of authentication for you. This means your application can now service users that have logged in on __NYU Libraries central login system's__ end. After logging in from __NYU Libraries central login system__, your client application then retrieves user data and logs the user in.

Your application then has an [_authhash_] that contains all the data you would need!

### Use the OmniAuth NYU Libraries Strategy
Fortunately __NYU Libraries central login system__ has an [OmniAuth strategy](https://github.com/NYULibraries/omniauth-nyulibraries) that you can use.

In your Gemfile:

```ruby
gem 'omniauth-nyulibraries'
```

Then run

```
$ bundle install
```

### How to get the authhash

Now that you know you of the power of the `authhash`, you must now wield it. To do this first set up some routes in your application.

#### Routes

In your `config/routes.rb` be sure to add this:

```ruby
devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
```

This will tell Devise to create the following routes for `Users`

```
user_omniauth_authorize GET|POST /users/auth/:provider(.:format)        users/omniauth_callbacks#passthru {:provider=>/nyulibraries/}

 user_omniauth_callback GET|POST /users/auth/:action/callback(.:format) users/omniauth_callbacks#(?-mix:nyulibraries)
```

Look familiar? This is the callback URL you added to __NYU Libraries central login system__ in the [first step](https://github.com/NYULibraries/login/blob/feature/client_documentation/GETTING_STARTED.md#adding-your-application-as-a-client)!


Now that you have the proper route that __NYU Libraries central login system__ can send the `authhash` to, you must now create a controller for that route.

#### Controllers

In `app/controllers`, create a controller to reflect your new route, complete with a namespace. This will be `app/controllers/users/omniauth_callback.rb`.

```ruby
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def nyulibraries
    @user = User.find_or_create_for_omniauth_authhash(request.env["omniauth.auth"])
    sign_in_and_redirect @user
  end
end
```

Did you catch that? The `request.env["omniauth.auth"]` is the formal way to retrieve the `authhash`. Once you've retrieved it, you can use it sign in the user. The method `User.find_or_create_for_omniauth_authhash()` doesn't yet exist, but for illustrative purposes it's goal is spelled out here.

You can set up more advanced controls, like flash messages or persistence options, as well as the ability to sign up.


#### User Model extra Methods

Recall the `User.find_or_create_for_omniauth_authhash()`. This illustrative method is implemented in the `User` model. Example configurations are as follows:

```ruby
  def self.find_or_create_for_omniauth_authhash(auth_data)
    User.find_or_create_by(uid: auth_data.uid)
  end
```

```ruby
  # Create by UID and provider
  def self.find_or_create_for_omniauth_authhash(auth_data)
    User.find_or_create_by(uid: auth_data.uid, provider: auth_data.provider)
  end
```

```ruby
  # Create by UID and Email
  def self.find_or_create_for_omniauth_authhash(auth_data)
    User.find_or_create_by(uid: auth_data.uid, email: auth_data.info.email)
  end
```

All we end up doing is using a simple `User.find_or_create_by()` method that exists in the `User` model. Now we have made a user (or found one), and in the `callback_controller.rb` we [login using this user](https://github.com/NYULibraries/login/GETTING_STARTED.md#Controllers).

#### Models

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
  def self.find_or_create_for_omniauth_authhash(auth_data)
    User.find_or_create_by(uid: auth_data.uid, provider: auth_data.provider)
  end
end
```

#### Views Helpers

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

And that's it! You can now login with __NYU Libraries central login system__ in the simplest way possible.
