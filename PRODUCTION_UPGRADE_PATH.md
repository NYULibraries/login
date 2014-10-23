# Production Upgrade Path

## Preparing Client Applications

Every (client) application that will be using Login for authentication will need to be prepared and deployed

Prepare old apps to be compatible with [Figs](https://github.com/NYULibraries/figs) and [Configula](https://github.com/NYULibraries/configula) for configurations, [Formaggio](https://github.com/NYULibraries/formaggio) for deployment, and [Nyulibraries-assets](https://github.com/NYULibraries/nyulibraries-assets) upgraded for Bootstrap 3.

Make these changes in dev and QA and deploy to production before beginning upgrade to include Login as the authentication method to ensure that we are only testing the Login functionality and not additional configuration upgrades.

### Ruby On Rails Applications

Upgrade the below Ruby on Rails applications in dev to use Login as the OAuth provider.

This will involve database migrations which will delete some existing user data but should integrate the new APIs from Login to get the user information on callback phase.

For all of these you will want to:

* Remove authpds as authentication method
* Database migrations
* Setup as OAuth2 client

#### For Apps That Care About Maintaining Old Data

These select apps need to maintain the old user table data to continue to link existing users to their saved data within the system:
* Room Reservation System
* MaRLi
* E-Shelf
* Umbra

So in the OAuth2 callback phase for these apps we will need to try to find the existing user similar to the following:

```ruby
@user ||= (User.find(username: uid, provider: provider) || User.find(username: uid, provider: ""))
```

#### For Apps That DON'T Care About Maintaining Old Data

These apps do not need to maintain user data since there are no saved records or reservations or additional app specific data that can not be retrieved on login from the API:

* GetIt
* Privileges
* Ichabod

In these cases we can set a capistrano task to clear user data before deploying to production as a one time task. This can be done locally since it's just an upgrade process and not necessarily something we want to build into Formaggio.

Implementation may differ but something along these lines:

```ruby
namespace :upgrade
  task :destroy_all_users
    User.destroy_all
  end
end
after "deploy", "upgrade:destroy_all_users"
```

**Each of these applications' upgrade requirements is detailed in a user story**

### Non-Rails Applications

The major application that needs to act as an OAuth2 client is PDS. This will allow login to BobCat, the Arch and ILLiad through Login.

##### The Arch Database

The Arch is the only of these apps that maintains a database of users. And along with these users are saved databases so it's important **NOT TO WIPE THIS DATABASE**. In the process of upgrading this app we should however remove the saved records since that is no longer supported functionality.

**Each of these applications' upgrade requirements is detailed in a user story**

## Production Database For Login

Login needs a high-availability multi-region PostgreSQL databases. On average the highest-use applications have around 50,000 users and this includes old users who no longer exist. This comes to ~140MB. A database of 1GB should be more than sufficient and all cloud hosted services allows scalable databases if we find the need for more.

We can continue to use Heroku but in a production capacity. Upgrading to the Premium tier will allow us to have HA and up to one week of rollback. Continuing to use Heroku will also allow us to utilize some of the cool data analyzing and visualizing tools.

**This is detailed in a user story**

## Ready For Production

To ready production applications for deploy. A simple deploy from Jenkins should make these login changes work in production.

### Update Production Config In Configula

Can happen at any time.

### Prepare Production Environment

#### The Cloud

Get an instance of Login running on Heroku and point the dev apps to it. The only initial blocker for this is the domain name.

#### Load-Balanced In-House

If we are not ready to run this service in the cloud by go-live time we will want two load-balanced servers (`login1.bobst.nyu.edu`, `login2.bobst.nyu.edu`) pointing to  `login.library.nyu.edu`.

## Production Path

Once all the dev and QA work has been done to prepare the applications and we've set up our production environment there are a set of tasks that need to be followed in order to allow for a seamless transition to the new Login.

### 1) Domain Switching

#### a. `pds.library.nyu.edu`

We will want to recommission this old domain name to point to PDS before production updates begin.

This will have to happen simultaneously with all production applications pointing their login URLs to `pds.library.nyu.edu`. But that is something that can be prepared in master for all production systems and as soon as the domain switch takes place we can deploy the jobs through Jenkins.

#### b. `login.library.nyu.edu`

At this point both `pds` and `login` will be pointing to the same old instance of PDS and all production applications should continue functioning as they have.

Once we're sure that all existing applications are pointing to `pds.library` we can ask for the domain switch to get `login.library` pointing to our new production Login application.

**We now have Login in production without affecting service to any other application**

### 2) Point QA Environments To `login.library.nyu.edu`

We want to test that all of our upgrades work with the new production environment and this new domain name.

This just involves a Configula change to the login URL and Jenkins deployments of QA environments.

### 3) Merge Changes To Master

#### a. Ready Jenkins To Deploy

Now that we're sure everything works we can ready our Jenkins jobs to deploy the client applications to productions by merging changes to the master branch.

The reason we didn't do this at any point before was that we were continuing to rollout the old application with changes to the login URL.

#### b. Change Login URL Yet Again

We will now also want to make sure that we change all these production applications login URL back to `login.library.nyu.edu` which of course is now the new app.

### 4) DEPLOY!!

Cross your fingers and deploy the Jenkins jobs for production applications.
