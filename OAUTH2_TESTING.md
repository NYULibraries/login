# Testing Login as an OAuth2 Provider

## What is OAuth2 and how does it work?

OAuth2 is an authentication framework that provides for an abstraction layer between the client application, i.e. NYU Libraries Login (Login), and the identity provider (or _resource server_ as the OAuth spec calls it), e.g. Shibboleth, Facebook, Twitter, etc.

What we want is for Login to be able to identify a given end-user (_resource owner_) without having to maintain that user's protected information. In effect our app is given a different set of credentials from the _resource server_, an access token, to identify that end-user.

Once the user is authenticated to the client app through the _resource server_, we can request user information from it, information that it cares to share.

## What is an OAuth2 Provider?

The same way we want Login to recognize users logging into Facebook, we want say GetIt to recognize users logging into Login. Login needs to be an OAuth2 Provider for this to work and to use the language from the specification, Login needs to be configured as a _resource server_.

[Doorkeeper](https://github.com/doorkeeper-gem/doorkeeper) sells itself well as "a gem that makes it easy to introduce OAuth 2 provider functionality to your application." And it even provides a [sample provider application](https://github.com/doorkeeper-gem/doorkeeper-provider-app), which we will use as a framework for testing some of the elements of a provider.

## Testing Login as an OAuth2 Provider

### Testing the API (Provider)

An OAuth2 provider is required to have an API path where one can request protected resources. The path would look something like `/api/v1/users?token=a1b2c3d4` where that returns a JSON body containing the authenticated user's protected information.

Given a valid token we expect this route to return a valid user represented as JSON.

#### Client App

In order to test the API we'll need to have a client app which is requesting authorization for the end-user.

There are a number of ways to do this: 

- We could test this provider as part of the testing suite from an actual client application
- We could create a full dummy app within Login's testing suite (too much overhead and too many variables for failure)
- We could mock a client application on the fly

This last one is the preferred way and the one we will be exploring. 

#### Controllers

Mocking a client application allows us to purely test the provider's response to what we can assume is a valid application using Login as authentication. Using the [doorkeeper provider sample app](https://github.com/doorkeeper-gem/doorkeeper-provider-app) as an example we can see how to mock a client app, create a fake token from a factory user and test the `#api` method via GET:

    # spec/controllers/api/v1/users_controller_spec.rb
    describe Api::V1::UsersController do

     before :each do
      request.env['devise.mapping'] = Devise.mappings[:user]
     end

     describe 'GET #api (integrated)' do

      let!(:application) { Doorkeeper::Application.create!(:name => "MyApp", :redirect_uri => "http://app.com") }
      let!(:user) { FactoryGirl.create(:user) }
      let!(:token) { Doorkeeper::AccessToken.create! :application_id => application.id, :resource_owner_id => user.id }

      it 'should respond with 200' do
        get :api, :format => :json, :access_token => token.token
        expect(response.status).to be 200
      end

      it 'should return the user as JSON' do
        get :api, :format => :json, :access_token => token.token
        expect(response.body).to eql user.to_json
      end
      
     end
    end

These simple tests make sure that, given a user known by the provider and a token created from that user's ID/Application combination, we can always retrieve a user's information from a GET to the `#api` method.

__TODO:__
Currently our `#api` is a bit of a budget method. It doesn't exist the modular way laid out above, that is within its own `Api::V1` module, but rather it's just a function within the `UsersController` that is routed to `/api/v1/user`. 

### Routes

Check that `/api/v1/user` routes correctly to the desired function within the controller.

Check the oauth endpoint routes.

### Integration

Writing integration Cucumber tests for this interaction poses an initial problem. Since we don't want to spin off a dummy application and run it side-by-side with Login (sounds like a headache) we will have to do a bit of mocking to create a dummy client. Luckily, though not without a bit of thought, there are ways to mock this client interaction.

#### Cucumber Feature

In a truly integrated test suite we might have specific features for each client application, this may in fact live in [Browbeat](https://github.com/NYULibraries/browbeat) and be run after each successful deploy of each dependent application. However, for the sake of creating features within Login which only test the specific provider responses to any generic client application we can word a feature as follows:

	@client
    Feature: Login as an OAuth2 Provider
      In order to use a specific NYU Libraries' online service
      As a user
      I want to login on NYU's central login page and be logged into that specific service

      Scenario: Logging into a client application
        Given I am on an NYU client application
        When I login
        Then NYU Libraries' Login authorizes me
        And I should be logged in to the NYU client application
 
And thank goodness the doorkeeper wiki is deep and well maintained because it provides us with a outline for testing a provider with a dummy client: [Testing your provider with OAuth2 gem](https://github.com/doorkeeper-gem/doorkeeper/wiki/Testing-your-provider-with-OAuth2-gem).

The first step of the above scenario cannot be checked and are is a convenience step to give the feature fluidity.

##### Before

In order to simulate a client application we can run this before each `@client` tagged feature:

	Before('@client') do
		@client = OAuth2::Client.new("123", "secret123", :site => "https://login.dev")
  		@redirect_uri = "http://example.com"
    end

##### `When I login` 

Force a login to the Login application, retrieve the authorization url and go there:

    When(/^I login$/) do
      login_user
      auth_url = @client.auth_code.authorize_url(:redirect_uri => @redirect_uri)
      visit auth_url
	  @auth_code = get_auth_code_from_url
    end

##### `Then NYU Libraries' Login authorizes me`

Retrieve the authorized access token:

    Then(/^NYU Libraries' Login authenticates me$/) do
		@token = @client.auth_code.get_token(@auth_code, :redirect_uri => @redirect_uri)
    end

##### `And I should be logged in to the NYU client application`

Ensure that the user information was found:

    And(/^I should be logged in to the NYU client application$/) do
		response = @token.get('/api/v1/users')
		expect(JSON.parse(response.body)).to eql oauth_user_hash.to_json
    end
