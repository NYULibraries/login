# Production Upgrade Path

## Preparing Client Applications

Every client application that will be using Login for authentication will need to be prepped by integrating:

* Rails 4
* [Figs](https://github.com/NYULibraries/figs) and
* [Configula](https://github.com/NYULibraries/configula) for configurations
* [Formaggio](https://github.com/NYULibraries/formaggio) for deployment

**Make these changes in dev and QA** first and then** deploy to production** before beginning the upgrade to Login to ensure that we limit the margin of error by only testing one change at a time.

### Ruby On Rails Applications

Upgrade the below Ruby on Rails applications in dev (and QA where it exists) to use Login as the OAuth2 provider.

This will involve database migrations which will delete some existing user data but should integrate the new APIs from Login to get the user information on callback phase.

For all of the following apps you will want to:

* Remove [authpds](https://github.com/scotdalton/authpds)/[authpds-nyu](https://github.com/NYULibraries/authpds-nyu) as the current  authentication method
* Database migrations to change the User model
* [Setup as OAuth2 client](https://github.com/NYULibraries/login/blob/development/GETTING_STARTED.md)

#### For Apps That Care About Maintaining Old Data

These select apps need to maintain the old user data to continue to link existing users to their saved data within the system:
* Room Reservation System
* MaRLi
* E-Shelf
* Umbra
* Ichabod
* Finding Aids

So in the OAuth2 callback phase for these apps we will need to try to find the existing user using something like this:

```ruby
@user ||= (User.find(username: uid, provider: provider) || User.find(username: uid, provider: ""))
```

Actual implementations may vary.

#### For Apps That DON'T Care About Maintaining Old Data

These apps do not need to maintain user data since there are no saved records, reservations, additional app specific data, etc. that cannot be retrieved on login from [the API](https://github.com/NYULibraries/login/blob/development/CONTRACT.md#hitting-the-api):

* GetIt
* Privileges Guide

In these cases we can set a Capistrano task to clear user data before deploying as a one-time task. This can be done locally since it's an upgrade process and not necessarily something we want to build into Formaggio.

Actual implementations may differ, but something along these lines should do it:

```ruby
namespace :upgrade
  task :destroy_all_users
    User.destroy_all
  end
end
after "deploy", "upgrade:destroy_all_users"
```

### Non-Rails Applications

PDS will need to act as an OAuth2 client allowing users of ILLiad and the Arch to continue to login with a valid session.

#### PDS

The pds-custom project can be significantly simplified since a lot of the code in there is now implemented in a cleaner fashion in Login.

However we will still need to create a PDS session from our Login OAuth2 payload. The existing login strategies that will need to be edited to do this are the [`sso`](https://github.com/NYULibraries/pds-custom/blob/master/lib/NYU/Libraries/PDS/SessionsController.pm#L594) and [`load_login`](https://github.com/NYULibraries/pds-custom/blob/master/lib/NYU/Libraries/PDS/SessionsController.pm#L561) methods where the former passively logs you in via SSO and the latter does so actively, with an actual click on "Login."

In Perl there are some strategies for receiving an OAuth2 payload:

* [Net::OAuth2](http://search.cpan.org/~kgrennan/Net-OAuth2-0.06/lib/Net/OAuth2.pm)
* [Net::OAuth2 on github](https://github.com/keeth/Net-OAuth2)
*  [Net::OAuth2::Profile::WebServer](http://search.cpan.org/~markov/Net-OAuth2-0.61/lib/Net/OAuth2/Profile/WebServer.pod)

#### The Arch

The Arch is the only of these apps that maintains a database of users. And along with these users are saved databases so it's important **NOT TO WIPE THIS DATABASE**. In the process of upgrading this app we should however remove the saved records since that is no longer supported functionality.

## Production Database For Login

Login needs a high-availability multi-region PostgreSQL databases. On average the highest-use applications have around 50,000 users and this includes outdated users. This comes to ~140MB. A database of 1GB should be more than sufficient and all cloud hosted services allow for scalable databases if we find the need for more space, etc.

We can continue to use Heroku but upgrade to a production capacity. Upgrading to the Premium tier will allow us to have HA and up to one week of rollback. Continuing to use Heroku will also allow us to utilize some of the cool data analyzing and visualizing tools.

## Prepare Production Environment

### The Cloud

Get an instance of Login running on Heroku and point the dev apps to it. The only initial blocker for this is the domain name.

### Load-Balanced In-House

If we are not ready to run this service in the cloud by go-live time we will want two load-balanced servers (`login1.bobst.nyu.edu`, `login2.bobst.nyu.edu`) ready to point to `login.library.nyu.edu`.

## Production Path

Once all the dev and QA work has been done to prepare the applications and we've set up our production environment there are a set of tasks that need to be followed in order to allow for a seamless transition to the new Login.

This list of apps will need to do the below dance to switch back and forth between production and dev URLs for login in order to maintain all production services without downtime:

* BobCat
* Room Reservation System
* MaRLi
* GetIt
* The Arch
* Umbra
* E-Shelf
* Privileges Guide
* ILLiad
* Ichabod
* Finding Aids

### 1) Domain Switching

#### a. `pds.library.nyu.edu`

We will want to recommission this old domain name to point to PDS before production updates begin.

This will have to happen simultaneously with all production applications pointing their login URLs to `pds.library.nyu.edu`. But that is something that can be prepared in the master branches for all production systems and as soon as the domain switch takes place we can deploy the jobs through Jenkins.

#### b. `login.library.nyu.edu`

At this point both `pds` and `login` will be pointing to the same old instance of PDS and all production applications should continue functioning as they have.

Once we're sure that all existing applications are pointing to `pds.library` we can ask for the domain switch to get `login.library` pointing to our new production Login application.

**We now have Login in production without affecting service to any other application**

### 2) Point QA Environments To `login.library.nyu.edu`

We want to test that all of our upgrades work with the new production environment and this new domain name, i.e. `login.library.nyu.edu`. **Note that the defualt URL for these applications is `dev.login.library.nyu.edu`**

This just involves a Configula change to the login URL and Jenkins deployments of QA environments.

### 3) Merge Changes To Master

#### a. Ready Jenkins To Deploy

Now that we're sure everything works we can ready our Jenkins jobs to deploy the client applications to production by merging changes to the respective master branches.

The reason we didn't do this at any point before was that we were continuing to rollout the old applications with changes to the login URL.

#### b. Change Login URL Yet Again

We will now also want to make sure that we change all these production applications login URL back to `login.library.nyu.edu` which of course is now the new app.

### 4) DEPLOY!!

Cross your fingers and deploy the Jenkins jobs for production applications.
