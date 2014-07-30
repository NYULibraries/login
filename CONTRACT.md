# NYULibraries Login API

The API is pretty straightforward. However you might have to make some changes to existing classes, for example you will have to add a column for the access_token in your `User` model.

```
rails g migration AddLoginAccessTokenToUsers nyu_access_token:string
```

This token allows you to interact with login's API. You will want to store this token when getting information from __Login__.


You may want to probably change the `User` model to include a method like this:

```ruby
  def self.find_or_create_for_omniauth(auth_data)
    @user = User.find_or_create_by(uid: auth_data.uid, email: auth_data.info.email).tap do |user|
      user.access_token = auth_data.credentials.token
      user.save!
    end
  end
```

Now you have everything you need to access the API.

## Exploring the API

Once you have your access token, you can use the following methods to interact with the API.

```ruby
  @client = OAuth2::Client.new(APP_ID, APP_SECRET, LOGIN_URL)
  @token = OAuth2::AccessToken.new(@client, current_user.access_token) if current_user
  @json = @token.get("api/v1/#{params[:api]}").parsed
```

The `@json` will give you a hash that contains all the information you need on the `User`. For example `@json['identities']` will give you any identities attached to that `User` from __Login__.
