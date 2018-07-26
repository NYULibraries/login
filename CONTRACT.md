# Contract

The NYU Libraries Login system is an OAuth2 provider that allows automatic authentication. Because of this, we have very strict requirements for becoming a client application. The documentation on the process of becoming a client application can be found in the [getting started guide](GETTING_STARTED.md). As an Oauth2 provider, all calls are made over HTTPS.

## Adding your application as a client

When you have become verified, you will have to provide us with a Callback URL. The callback URL is the endpoint to which the authentication system will send data.

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

Finally, you are able to access the user information by running a request for the user resource as `json`.

This is an example request, to be replaced with appropriate values.
```
$ curl --header "Authorization: Bearer ACCESS_TOKEN" localhost:3000/api/v1/user.json
{"id":1,"username":"username",...,"identities":[{...},...]}
```

## Rack Based

If you are using a Rack Based application, you have free reign to use the [omniauth-nyulibraries gem](https://github.com/NYULibraries/omniauth-nyulibraries). This provides easier access to the provider API.

## Passive Login

The NYU Libraries Login system allows users to passively login to your app if the user has already logged into the main provider. This can be implemented using HTTP redirects.

### Passive Login Flow

When the user hits your application, and is not logged in, your app checks to see if a certain cookie exists. We call it `_check_passive_login`. If the cookie exists, then the app knows that the user has visited the app before and was not logged in to the central login system. If the cookie doesn't exist, the app should check to see if the user is indeed logged in. To do this it sets the aforementioned cookie, and then redirects to Login's passive check URI with certain parameters.

```
LOGIN_URL/login/passive?client_id=APP_ID&return_uri=RETURN_URI
```

The `APP_ID` is the ID Login assigns to your app. The `RETURN_URI` is where Login should return to if the user is not logged in, typically it is set to the app's current url.

Additionally if your app's login URL is different from the standard YOUR_APP_URL/login, you can specify the login path with the `login_path` parameter.

```
LOGIN_URL/login/passive?client_id=APP_ID&return_uri=RETURN_URI&login_path=NEW_PATH
```

Important note, your NEW_PATH must have the same hostname and port as your application.

#### For Rails

With Rails you can simply do the following in your `ApplicationController`.

```ruby
class ApplicationController < ActionController::Base
  #...
  prepend_before_action :passive_login
  #...
  def passive_login
    if !cookies[:_check_passive_login]
      cookies[:_check_passive_login] = true
      redirect_to "#{LOGIN_URL}?client_id=#{APP_ID}&return_uri=#{RETURN_URI}&login_path=#{NEW_PATH}"
    end
  end
  #...
  # This makes sure you redirect to the correct location after passively
  # logging in or after getting sent back not logged in
  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end
end
```

Or the more fleshed out version we use in our apps:

```ruby
class ApplicationController < ActionController::Base
  #...
  prepend_before_action :passive_login
  def passive_login
    if !cookies[:_check_passive_login]
      cookies[:_check_passive_login] = true
      redirect_to passive_login_url
    end
  end
  #...
  # This makes sure you redirect to the correct location after passively
  # logging in or after getting sent back not logged in
  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || stored_location_for(resource) || root_path
  end
  #...
  private

  def passive_login_url
    "#{ENV['LOGIN_URL']}#{ENV['PASSIVE_LOGIN_PATH']}?client_id=#{ENV['APP_ID']}&return_uri=#{request_url_escaped}&login_path=#{login_path_escaped}"
  end

  def request_url_escaped
    CGI::escape(request.url)
  end

  def login_path_escaped
    CGI::escape("#{Rails.application.config.action_controller.relative_url_root}/login")
  end
end
```

### Conclusion

The end flow would be like so:

  - Is user logged in?
    - __Yes__
      - Problem solved!
    - __No__
      - Has the `_check_passive_login` cookie been set?
        - __Yes__
          - Problem solved!
        - __No__
          - Set `_check_passive_login` cookie
          - Redirect to `LOGIN_URL/login/passive?client_id=APP_ID&return_uri=RETURN_URI`
