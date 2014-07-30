# Getting Started

To use __NYU Libraries central login system__ as your OAuth2 provider, you must first register your application as a client for [Login](https://github.com/NYULibraries/login). This will tell __Login__ where the client applications callback URL is.

To do so, you must have access to an Admin account in __Login__.

## Adding your application as a client

  1. Login to __NYU Libraries central login system__ as an admin.
  2. Visit the applications page (located at __/oauth/applications__).
  3. Click __Add new application__
  4. Enter your client Application's title and it's callback URL (it will probably be '/users/auth/doorkeeper/callback').
  5. Click submit.

Congrats, your application is now a client. You will be given a unique __Application Id__ and __Application Secret__. These two keys are very important, and they will be used by your client app to communicate with __Login__ via an API.

## Integrating

### Gemfile
__Login__ uses [Doorkeeper](https://github.com/doorkeeper-gem/doorkeeper), [Devise](https://github.com/plataformatec/devise), and [OmniAuth](https://github.com/intridea/omniauth), so it would be extremely helpful for the client app to do have at least OmniAuth and Devise.

In your Gemfile:

```ruby
gem 'devise'
gem 'omniauth'
gem 'omniauth-oauth2'
```

### Config

Once you've got Devise and OmniAuth installed in your app (learn how to [here](https://github.com/plataformatec/devise/wiki) and [here](https://github.com/intridea/omniauth) respectively), you can add __Login__ to your app as the provider. Simply go to the __config > initializers__ directory and locate __devise.rb__.

```ruby
Devise.setup do |config|
#...
config.omniauth :nyulibraries,  YOUR_APP_KEY, YOUR_APP_SECRET, :client_options =>  {:site => LOGIN_URL}
#...
end
```

Where `YOUR_APP_KEY` and `YOUR_APP_SECRET` are __Application Id__ and __Application Secret__ retrieved from registering your app in __Login__. `LOGIN_URL` would be the URL for __Login__.


### Models

It'll be a good idea to have a `uid` field in your `User` devise model (assuming you succesfully implemented Devise). You can also add a `provider` field as well if you feel like, making user lookups based on both `uid` and `provider` (or `email` if you want to go that route).

```ruby
rails g migration AddUidToUsers uid
# rails g migration AddUidToUsers uid provider email ...
rake db:migrate
```

After that, you must make your Model `Omniauthable`.

```ruby
devise :omniauthable
```


### Routes

Now it's a good idea to set up your routes to point in the right direction. In your `config/routes.rb` be sure to add this:

```ruby
devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
```

This will tell Devise to create the following routes for `Users`

```
user_omniauth_authorize GET|POST /users/auth/:provider(.:format)        users/omniauth_callbacks#passthru {:provider=>/nyulibraries/}

 user_omniauth_callback GET|POST /users/auth/:action/callback(.:format) users/omniauth_callbacks#(?-mix:nyulibraries)
```

These controllers don't exist, so you'll have to make them.

### Controllers

You'll have to make a controller in `app/controllers`,which will be `app/controllers/users/omniauth_callback.rb`. Something like this will suffice.

```ruby
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def nyu
    @user = User.find_or_create_for_omniauth(request.env["omniauth.auth"])
    sign_in_and_redirect @user
  end
end
```

You can set up more advanced controls, like flash messages or persistence options, as well as the ability to sign up. You can see that we have to create the method `User.find_or_create_for_omniauth`, but that goes back in the `User` model.

### User Model extra Methods

So a simple `find_or_create_by` is all we need.

```ruby
  def self.find_or_create_for_omniauth(auth_data)
    User.find_or_create_by(uid: auth_data.uid)
  end
```

If you had a `provider` field or a `email` field (which you probably want), you may need to modify accordingly.

```ruby
  def self.find_or_create_for_omniauth(auth_data)
    User.find_or_create_by(uid: auth_data.uid, email: auth_data.info.email)
  end
```

### Views Helpers

Available to you are now fancy view helpers

```ruby
<%= link_to "Sign in with NYU Login", user_omniauth_authorize_path(:nyulibraries) %>
```

And that's it! You can now login with __NYU Libraries central login system__ in the simplest way possible.
