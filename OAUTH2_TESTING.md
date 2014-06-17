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

An OAuth2 provider is required to have an API path where one can request protected resources. The path would look something like `/api/v1/user?token=a1b2c3d4` where that returns a JSON body containing the authenticated user's protected information.

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

      let(:user) { create(:user) }

      describe 'GET #api' do

        let(:app) { create(:oauth_application) }
        let(:token) { Doorkeeper::AccessToken.create! :application_id => app.id, :resource_owner_id => user.id }

        it 'responds with 200' do
          get :show, :format => :json, :access_token => token.token
          expect(response.status).to be 200
        end

        it 'returns the user as json' do
          get :show, :format => :json, :access_token => token.token
          expect(response.body).to eql user.to_json(:include => :identities)
        end
      end

    end

These simple tests make sure that, given a user known by the provider and a token created from that user's ID/Application combination, we can always retrieve a user's information from a GET to the `#show` method.

### Routes

Check that `/api/v1/user` routes correctly to the desired function within the controller.

Check the oauth endpoint routes.

### Integration

Writing integration Cucumber tests for this interaction poses a problem. Since we don't want to spin off a dummy application and run it side-by-side with Login (sounds like a headache) we will have to do a bit of mocking to create a dummy client. There appear to be ways to hack together a mocked client, but currently I could not get this to work. Following is the process I tried:

#### Cucumber Feature

In a truly integrated test suite we might have specific features for each client application, this may in fact live in [Browbeat](https://github.com/NYULibraries/browbeat) and be run after each successful deploy of each dependent application. However, for the sake of creating features within Login which only test the specific provider responses to any generic client application we want to word a feature as follows:

    @omniauth_test
    Feature: Login as an OAuth2 Provider
      In order to use a specific NYU Libraries' online service
      As a user
      I want to login on NYU's central login page and be logged into that specific service

	  @client_app
      Scenario: Logging into a client application
        Given I am on an NYU client application
        When I login
        Then NYU Libraries' Login authorizes me
        And I should be logged in to the NYU client application

The doorkeeper wiki provides an outline for testing a provider with a dummy client: [Testing your provider with OAuth2 gem](https://github.com/doorkeeper-gem/doorkeeper/wiki/Testing-your-provider-with-OAuth2-gem). This provides a process for creating on the fly client applications and getting an access token from them. I could not get this to work mainly when trying to point [Faraday](https://github.com/lostisland/faraday), which the `Client` class of the OAuth2 gem wraps, to the RackTest application in either Capybara or RSpec. They do have [recommendations for doing this](https://github.com/doorkeeper-gem/doorkeeper/wiki/Testing-your-provider-with-OAuth2-gem#rspec) but I could not make it work.

##### `Before` and `After`

The `@omniauth_test` tag just sets up the [OmniAuth test environment](https://github.com/intridea/omniauth/wiki/Integration-Testing) so we can simulate login.

In order to simulate a client application I tried running this before each `@client_app` tagged feature:

    Warden.test_mode!
    World Warden::Test::Helpers

    Before('@client_app') do
      @app = FactoryGirl.create(:oauth_app_no_redirect)
      @client = OAuth2::Client.new(@app.uid, @app.secret) do |b|
        b.request :url_encoded
        b.adapter :rack, Rails.application
      end
      @admin_user = FactoryGirl.create(:admin)
    end

And this after:

    After('@client_app') do
      Warden.test_reset!
    end

The use of the Warden test helpers are documented here: [Test with Capybara](https://github.com/plataformatec/devise/wiki/How-To:-Test-with-Capybara),

##### `When I login`

Force a login to the Login application, retrieve the authorization url and go there:

    When(/^I login$/) do
      login_as(@admin_user, scope: :user)
      auth_url = @client.auth_code.authorize_url(:redirect_uri => @app.redirect_uri)
      visit auth_url
      @auth_code = retrieve_auth_code_from_current_page
    end

This never redirects to the proper RackTest environment. The URL comes through in the form `http:/oauth/...`

Using the test `redirect_uri` we are supposed to see a page containing the auth_code, so we would screen scrape it here with a helper function such as `retrieve_auth_code_from_current_page`.

##### `Then NYU Libraries' Login authorizes me`

Next try to retrieve the authorized access token:

    Then(/^NYU Libraries' Login authenticates me$/) do
      @token = @client.auth_code.get_token(@auth_code, :redirect_uri => @app.redirect_uri)
    end

##### `And I should be logged in to the NYU client application`

Then we should be able to use that token to visit the API:

    And(/^I should be logged in to the NYU client application$/) do
      response = @token.get('/api/v1/users')
      expect(JSON.parse(response.body)).to eql FactoryGirl.build(:admin_user).to_json
    end
