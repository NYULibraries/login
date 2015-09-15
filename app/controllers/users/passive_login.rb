# Module containing all logic for passive login in this application, the server
# and the calling clients
#
# Strategy:
# - Client applications call GET /login/passive which
#   1) If they ARE logged in to Login redirect them to the client login url
#   2) If they are NOT logged in, check Shibboleth
#     a) If Shibboleth is LOGGED IN passively then redirect to the Login
#        nyu_shibboleth login url
#     b) If Shibboleth is NOT LOGGED IN passively redirect to the previous action,
#        which is client_passive_login, let that function handle redirection
#        back to the client app
module Users
  module PassiveLogin

    PASSIVE_SHIBBOLETH_URL_STRING = "/Shibboleth.sso/Login?isPassive=true&target="
    SHIBBOLETH_COOKIE_PATTERN = "_shibsession_"

    def self.included(base)
      base.prepend_before_filter :shibboleth_passive_login_check, only: [:client_passive_login]
      base.prepend_before_filter :save_return_uri
    end

    # GET /login/passive?return_uri=&client_id=[&login_path=]
    # Log client in if SP is logged in
    # otherwise pass back to original uri
    #
    # @return_uri             Where to return to after done here, defaults to root_path
    # @client_id              Valid Doorkeeper APP_ID that matches the host of the return_uri
    # @login_path [optional]  Where to send client to login if logged in passively, defaults to /users/auth/nyulibraries
    def client_passive_login
      return_uri = session[:_return_uri]
      session[:_return_uri] = nil
      client_app = client_app(params[:client_id])
      login_path = params[:login_path] || '/users/auth/nyulibraries'
      # If user is signed in
      # redirect to client login
      if user_signed_in? && client_app.present?
        client_authorize_url = URI.join(URI.parse(client_app.redirect_uri), login_path, "?origin=#{CGI::escape(return_uri)}")
        redirect_to "#{client_authorize_url}"
      # If the user is not signed in but there is a return URI
      # send the user back there
      elsif return_uri.present?
        redirect_to return_uri
      else
        head :bad_request
      end
    end

    # GET /login/passive_shibboleth?origin=
    # Callback function for passive shibboleth
    #
    # @origin     Where to return to after done here, or after done logging in
    def shibboleth_passive_login
      # This is the original action called
      # before checking if we were logged in
      origin = params[:origin] if params[:origin]
      # If there is a session, authenticate the user
      if shib_session_exists?
        redirect_to user_omniauth_authorize_path(:nyu_shibboleth, institute: current_institute.code, auth_type: :nyu, origin: origin)
      # If there is no session, redirect back to the last action
      else
        redirect_to origin || root_url
      end
    end

    # Interrupt and send user out to passively login,
    # if the Idp has a session
    def shibboleth_passive_login_check
      unless user_signed_in? || session[:_check_passive_shibboleth]
        session[:_check_passive_shibboleth] = true
        # Set the redirect to a callback function that we'll handle
        # Double escape the eventual origin
        target_url = "#{CGI::escape("#{passive_shibboleth_url}?origin=#{CGI::escape(request.url)}")}"
        redirect_to "#{PASSIVE_SHIBBOLETH_URL_STRING}#{target_url}"
      end
    end
    private :shibboleth_passive_login_check

    # Check if the shibboleth session has been started
    # based off cookie pattern. This is a weak check as it can be
    # spoofed but if it was an we try to authenticate the error will
    # be raised then
    def shib_session_exists?
      !cookies.detect {|key, val| key.include? SHIBBOLETH_COOKIE_PATTERN }.nil?
    end
    private :shib_session_exists?

    # Get the client app based on the passed in client_id param
    def client_app(client_id)
      client_app = Doorkeeper::Application.all.find do |app|
        app.uid == client_id
      end
      return client_app
    end
    private :client_app

    # Save the return uri if it exists and is whitelisted
    def save_return_uri
      session[:_return_uri] = params[:return_uri] if whitelisted_return_uri?
    end
    private :save_return_uri

    # Whitelist return uri if their host matches the Doorkeeper redirect_uri host
    def whitelisted_return_uri?
      (params[:return_uri].present? &&
        params[:client_id].present? &&
          (URI::parse(client_app(params[:client_id]).redirect_uri).host == URI::parse(params[:return_uri]).host))
    rescue
      # If for some reason we can't parse the client_id
      # or the return_uri is not a valid URI, just return false
      false
    end
    private :whitelisted_return_uri?

  end
end
