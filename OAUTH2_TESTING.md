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

Mocking a client application allows us to purely test the provider's response to what we can assume is a valid application using Login as authentication. Using the [doorkeeper provider sample app](https://github.com/doorkeeper-gem/doorkeeper-provider-app) as an example we can see how to mock a client app, create a fake token from a factory user and test the `#show` method via GET:

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

Writing integration Cucumber tests for this interaction poses a problem. Since we don't want to spin off a dummy application and run it side-by-side with Login (sounds like a headache) we will have to do a bit of mocking to create a dummy client. There appear to be ways to hack together a mocked client as outlined below:

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

The doorkeeper wiki provides an outline for testing a provider with a dummy client: [Testing your provider with OAuth2 gem](https://github.com/doorkeeper-gem/doorkeeper/wiki/Testing-your-provider-with-OAuth2-gem). This provides a process for creating on the fly client applications and getting an access token from them. 

I could not get this to work  when trying to point [Faraday](https://github.com/lostisland/faraday), which the `Client` class of the OAuth2 gem wraps, to the RackTest application in either Capybara or RSpec. They do have [recommendations for doing this](https://github.com/doorkeeper-gem/doorkeeper/wiki/Testing-your-provider-with-OAuth2-gem#rspec) but I could not make it work.

Instead in a before step I made sure the current RackTest which Capybara was using and captured the URL, as seen below in the Before.

##### `Before` 

The `@omniauth_test` tag just sets up the [OmniAuth test environment](https://github.com/intridea/omniauth/wiki/Integration-Testing) so we can simulate login.

In order to simulate a client application I tried running this before each `@client_app` tagged feature:

    Before('@client_app') do
  	  visit login_path
	  url = URI.parse(current_url)
	  @site = "#{url.scheme}://#{url.host}:#{url.port}"
    end
 
Now I can use `@site` as intended when creating a client. However, this might have been the cause of some threading issues when trying to use DatabaseCleaner in transaction mode, hence causing inconsistencies between what the Capybara driver was seeing as "in the database." To solve this, in the Cucumber `env.rb` I changed the `DatabaseCleaner.strategy` to `:truncation`.

Additionally I'm assuming the existence of a client application from a factory and hence the following is wrapped by a helper:

    @oauth_app ||= FactoryGirl.create(:oauth_app_no_redirect)

##### `Given I am on an NYU client application`

Setting up a test client application in helpers via a helper method wrapping:

    @client ||= OAuth2::Client.new(oauth_app.uid, oauth_app.secret, site: @site) unless @site.blank?
    
Allows me to make the following assertions:

	Given(/^I am on an NYU client application$/) do
  	  expect(client).not_to be_nil
      expect(client).to be_instance_of OAuth2::Client
    end

##### `I login via NYU Shibboleth`

Force a login to the Login application, retrieve the authorization url and go there:

    When(/^I login$/) do
  	  # Log user in via NYU Shibboleth
	  login_as_nyu_shibboleth
	  # Visit the callback to ensure login and user creation
	  visit nyu_home_url
	  # Make sure this user is authorized for this app
	  oauth_app.authorized_tokens.create(resource_owner_id: current_resource_owner.id)
    end

##### `NYU Libraries' Login authorizes me for the client application`

Using the Doorkeeper recommended test `redirect_uri`, which is `urn:ietf:wg:oauth:2.0:oob`, we are supposed to see a page containing the auth_code and not get redirected to a real uri with `code=token` in the querystring. So we screen scrape it here with a helper function:

    @auth_code ||= page.find("#authorization_code").text

But only after we've visited the auth_url which we've pulled out like so:

    @auth_url ||= client.auth_code.authorize_url(:redirect_uri => oauth_app.redirect_uri)

The combination of leveraging these helper functions in a clean cucumber step follows:

    Then(/^NYU Libraries' Login authenticates me$/) do
  	  # Visit the auth url for this client
 	  visit auth_url
  	  expect(auth_code).to have_content
    end

##### `And I should be logged in to the NYU client application`

Then we should be able to use the token to visit the API:

    And(/^I should be logged in to the NYU client application$/) do
  	  # Visit the protected API
  	  visit api_v1_user_path(:access_token => access_token)
  	  expect(body).to include current_resource_owner.to_json(include: :identities)
    end
