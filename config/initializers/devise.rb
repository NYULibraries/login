# Have to set the full_host for this application for Devise when using OmniAuth
# So OmniAuth knows where to redirect back
#
# Set the full host to configured full url if it exists in the environment
# or to the current rack application for testing
rack_url = lambda do |env|
  scheme         = env['rack.url_scheme']
  local_host     = env['HTTP_HOST']
  forwarded_host = env['HTTP_X_FORWARDED_HOST']
  forwarded_host.blank? ? "#{scheme}://#{local_host}" : "#{scheme}://#{forwarded_host}"
end
OmniAuth.config.full_host = (ENV['LOGIN_APP_HOST'] || rack_url)

# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
Devise.setup do |config|
  # The secret key used by Devise. Devise uses this key to generate
  # random tokens. Changing this key will render invalid all existing
  # confirmation, reset password and unlock tokens in the database.
  if Rails.env.development? || Rails.env.test?
    config.secret_key = ('x' * 128)
  else
    config.secret_key = ENV['DEVISE_SECRET_KEY']
  end

  # ==> Mailer Configuration
  # Configure the e-mail address which will be shown in Devise::Mailer,
  # note that it will be overwritten if you use your own mailer class with default "from" parameter.
  config.mailer_sender = "lib-no-reply@nyu.edu"

  # Configure the class responsible to send e-mails.
  # config.mailer = "Devise::Mailer"

  # pre-4.1 defaults
  config.email_regexp = /\A[^@\s]+@([^@\s]+\.)+[^@\W]+\z/
  config.reconfirmable = false

  # ==> ORM configuration
  # Load and configure the ORM. Supports :active_record (default) and
  # :mongoid (bson_ext recommended) by default. Other ORMs may be
  # available as additional gems.
  require 'devise/orm/active_record'

  # ==> Configuration for any authentication mechanism
  # Configure which keys are used when authenticating a user. The default is
  # just :email. You can configure it to use [:username, :subdomain], so for
  # authenticating a user, both parameters are required. Remember that those
  # parameters are used only when authenticating and not when retrieving from
  # session. If you need permissions, you should implement that in a before filter.
  # You can also supply a hash where the value is a boolean determining whether
  # or not authentication should be aborted when the value is not present.
  config.authentication_keys = [ :username ]

  # Configure parameters from the request object used for authentication. Each entry
  # given should be a request method and it will automatically be passed to the
  # find_for_authentication method and considered in your model lookup. For instance,
  # if you set :request_keys to [:subdomain], :subdomain will be used on authentication.
  # The same considerations mentioned for authentication_keys also apply to request_keys.
  # config.request_keys = []

  # Configure which authentication keys should be case-insensitive.
  # These keys will be downcased upon creating or modifying a user and when used
  # to authenticate or find a user. Default is :email.
  config.case_insensitive_keys = [ :username ]

  # Configure which authentication keys should have whitespace stripped.
  # These keys will have whitespace before and after removed upon creating or
  # modifying a user and when used to authenticate or find a user. Default is :email.
  config.strip_whitespace_keys = [ :username ]

  # By default Devise will store the user in session. You can skip storage for
  # :http_auth and :token_auth by adding those symbols to the array below.
  # Notice that if you are skipping storage for all authentication paths, you
  # may want to disable generating routes to Devise's sessions controller by
  # passing :skip => :sessions to `devise_for` in your config/routes.rb
  config.skip_session_storage = [:http_auth]

  # ==> Configuration for :validatable
  # Range for password length. Default is 8..128.
  config.password_length = 0..0

  # The default HTTP method used to sign out a resource. Default is :delete.
  config.sign_out_via = :delete

  # ==> OmniAuth
  # Add a new OmniAuth provider. Check the wiki for more information on setting
  # up on your models and hooks.
  require "omniauth-twitter"
  config.omniauth :twitter, ENV['TWITTER_APP_KEY'], ENV['TWITTER_APP_SECRET']
  require "omniauth-shibboleth"
  # https://wiki.shibboleth.net/confluence/display/SHIB2/NativeSPSpoofChecking
  config.omniauth :shibboleth,
    name: 'nyu_shibboleth',
    uid_field: 'uid',
    info_fields: {
      email: 'email',
      nickname: 'givenName' ,
      first_name: 'givenName',
      last_name: 'sn'
    },
    extra_fields: ['nyuidn', 'entitlement'],
    request_type: (Rails.env.test?) ? :params : (ENV['SHIBBOLETH_REQUEST_TYPE_HEADER']) ? :header : :env
  require "omniauth-ldap"
  config.omniauth :ldap,
    name: 'new_school_ldap',
    host: ENV['NEWSCHOOL_LDAP_HOST'],
    port: ENV['NEWSCHOOL_LDAP_PORT'],
    bind_dn: ENV['NEWSCHOOL_LDAP_BIND_DN'],
    password: ENV['NEWSCHOOL_LDAP_PASSWORD'],
    base: ENV['NEWSCHOOL_LDAP_BASE'],
    uid: ENV['NEWSCHOOL_LDAP_UID'],
    method: :ssl,
    form: ->(env) {}
  require "omniauth-aleph"
  config.omniauth :aleph,
    host: ENV['ALEPH_HOST'],
    library: ENV['ALEPH_LIBRARY'],
    sub_library: ENV['ALEPH_SUB_LIBRARY'],
    form: ->(env) {}

end
