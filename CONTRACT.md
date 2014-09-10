# Contract

The NYU Libraries Central Login system is an OAuth2 provider that allows automatic authentication. Because of this, we have very strict requirements for becoming a client application. The documentation on the process of becoming a client application will be coming soon.

## Adding your application as a client

When you have become verified, you will have to provide us with a Callback URL. The callback URL is the URL endpoint that the authentication system will send data to.


# Configuration

## Getting an Access Token
Before you can begin authenticating users, your application will need an Access Token. The Access Token, provided by NYU Libraries Central Login system, will allow you to access to the API.

 * __ROUTE__: `/oauth/authorize`
 * __METHOD__: `GET`
 * __PARAMETERS__:
  - `client_id=` - Obtained from NYU Libraries Central Login system by setting up your application as a client application
  - `redirect_uri=` - CALLBACK_URL, Your applications endpoint URL. Login system will redirect to this URL.
  - `state=` - The STATE_TOKEN
  - `response_type=code` - Tells the provider to give an ACCESS_TOKEN, called code, as a response.
 * __RESPONSE__:
 ```
 HTTP/1.1 302 Found
 Location: CALLBACK_URL?code=ACCESS_TOKEN&state=STATE_TOKEN
 ```



__STATE_TOKEN__ - The State token is a anti-forgery measure that creates a state session between your application and the central Login system. You can create a state token by randomly generating a large number of characters, or hashing some state variables. In any case, the state token should be large and random. Finally, you must then set a session variable in your application named 'state' with the __STATE_TOKEN__ value.


Now you are ready to obtain an Access Token, this is an example request, to be replaced with appropriate values.

```
$ curl -H "Accept: text/javascript" "localhost:3000/oauth/authorize?client_id=CLIENT_ID&redirect_uri=CALLBACK_URL&state=STATE_TOKEN&response_type=code"
You need to sign in or sign up before continuing.
```
Upon requesting an access token, the login system will give the user the option to login. After logging in, it will redirect back to your application.



This will hit your Callback URL with the appropriate token. Your callback URL is responsible for storing this token for future API calls.

## Using the Access Token

* __ROUTE__: `/oauth/token`
* __METHOD__: `POST`
* __PARAMETERS__:
  - `client_id=` - Obtained from NYU Libraries Central Login system by setting up your application as a client application
  - `client_secret=` - Obtained from NYU Libraries Central Login system by setting up your application as a client application
  - `code=` - ACCESS_TOKEN, obtained from the previous step.
  - `redirect_uri=` - CALLBACK_URL, Your applications endpoint URL. Login system will redirect to this URL.
  - `grant_type=authorization_code` - Use the access token to grant  access.
* __RESPONSE__:
```
HTTP/1.1 200 OK
{"access_token":ACCESS_TOKEN,"token_type":"bearer","expires_in":7200}
```

Once you have the access token, you must make another request to authenticate yourself. This is a POST command that tells the Login System what access token you're using, which in turn verifies that it has not expired and matches the client application.

This is an example request, to be replaced with appropriate values.

```
$ curl --data "client_id=CLIENT_ID&client_secret=CLIENT_SECRET&code=ACCESS_TOKEN&redirect_uri=CALLBACK_URL&grant_type=authorization_code" "localhost:3000/oauth/token"
{"access_token":ACCESS_TOKEN,"token_type":"bearer","expires_in":7200}
```

## Hitting the API
* __ROUTE__: `/api/v1/user.json`
* __METHOD__: `GET`
* __HEADERS__:
  - `Authorization: Bearer ACCESS_TOKEN` - The header in this HTTP call is the authorization provided by the ACCESS_TOKEN.
* __RESPONSE__:
```
HTTP/1.1 200 OK
{"id":1,"username":"username",...,"identities":[{...},...]}
```

Finally, you are able to access the user information by running a request for the user resource as a `json`.


This is an example request, to be replaced with appropriate values.
```
$ curl --header "Authorization: Bearer ACCESS_TOKEN" localhost:3000/api/v1/user.json
{"id":1,"username":"username",...,"identities":[{...},...]}
```

## Rack Based

If you are using a Rack Based application, you have free reign to use the [omniauth-nyulibraries gem](https://github.com/NYULibraries/omniauth-nyulibraries). This provides easier access to the provider API.
