# Getting Started

__NYU Libraries Login__ is an OAuth2 provider. To use the system as your authentication provider, you must first register your application as a client with application admins. This will authorize your application and tell the login system where to find your callback URL.

## Providers and Clients

As mentioned above, NYU Libraries Login is an Oauth2 provider. What this means is that after a user is authenticated by this application, their data can be authorized by the Login system to another _client_ application without user interaction, provided that _client_ is registered within the login system as a __Client Application__.

The 'Client Application' will be the role that your application will play when trying to connect to NYU Libraries Login.

## Adding your application as a client

  1. Login to NYU Libraries Login system as an admin, [https://login.library.nyu.edu](https://login.library.nyu.edu)
  2. Visit the applications page (located at __/oauth/applications__)
  3. Click _Add new application_
  4. Enter your client application's title and it's callback URL (it will probably be '/users/auth/nyulibraries/callback')
  5. Click submit

Congrats, your application is now a client. You will be given a unique __Application Id__ and __Application Secret__. These two keys are very important, and they will be used by your client app to communicate with the login system via an API.

## Integrating

Now that your application is a client, now is a good time to find out what that means. Your application can now ask Login to handle any sort of authentication for you. This means your application can now service users that have logged in on NYU Libraries Login's end. After logging in from the central login system, your client application then retrieves user data and logs the user in.

Your application then has an [_auth_hash_](https://github.com/NYULibraries/omniauth-nyulibraries#example-auth-hash) that contains all the data you would need!

Before you begin, be sure you've got Devise and OmniAuth installed in your application (learn how to [here](https://github.com/plataformatec/devise/wiki) and [here](https://github.com/intridea/omniauth) respectively).

### Use the OmniAuth NYU Libraries Strategy
Fortunately the NYU Libraries central login system has an [OmniAuth strategy](https://github.com/NYULibraries/omniauth-nyulibraries) that you can use. Follow [these directions to install the strategy](https://github.com/NYULibraries/omniauth-nyulibraries#installation) before checking out our [Contract](CONTRACT.md).
