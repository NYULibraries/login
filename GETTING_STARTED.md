# Getting Started

__NYU Libraries central login system__ acts as an authentication method by being an OAuth2 provider. __NYU Libraries central login system allows automatic authentication, thus not all client applications will be authenticatable by NYU Libraries central login system, only admins can allow clients access__. To use __NYU Libraries central login system__ as your OAuth2 provider, you must first register your application as a client for [Login](https://github.com/NYULibraries/login). This will tell __Login__ where the client applications callback URL is.

To do so, you must have access to an Admin account in __Login__.

## Providers and Clients

__NYU Libraries central login system__ is an Oauth2 Provider. What this means is that after a user is authenticated by this application, their data can be authorized to another _client_ application provided that _client_ is registered within __NYU Libraries central login system__ as a __Client Application__.

The __Client Application__ will be the role that you application will play when trying to connect to __NYU Libraries central login system__.

## Adding your application as a client

  1. Login to __NYU Libraries central login system__ as an admin.
  2. Visit the applications page (located at __/oauth/applications__).
  3. Click __Add new application__
  4. Enter your client Application's title and it's callback URL (it will probably be '/users/auth/nyulibraries/callback').
  5. Click submit.

Congrats, your application is now a client. You will be given a unique __Application Id__ and __Application Secret__. These two keys are very important, and they will be used by your client app to communicate with __Login__ via an API.

## Integrating

Now that your application is a client, now is a good time to find out what that means. Your application can now ask __NYU Libraries central login system__ to handle any sort of authentication for you. This means your application can now service users that have logged in on __NYU Libraries central login system's__ end. After logging in from __NYU Libraries central login system__, your client application then retrieves user data and logs the user in.

Your application then has an [_auth_hash_](https://github.com/NYULibraries/omniauth-nyulibraries#example-auth-hash) that contains all the data you would need!

Before you begin, be sure you've got Devise and OmniAuth installed in your application (learn how to [here](https://github.com/plataformatec/devise/wiki) and [here](https://github.com/intridea/omniauth) respectively).

### Use the OmniAuth NYU Libraries Strategy
Fortunately __NYU Libraries central login system__ has an [OmniAuth strategy](https://github.com/NYULibraries/omniauth-nyulibraries) that you can use. Follow [these directions to install the strategy](https://github.com/NYULibraries/omniauth-nyulibraries#installation) before checking out our [Contract]().
