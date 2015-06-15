module Users::WhitelistedApplications
  private

  def whitelisted_client
    @whitelisted_client ||= Doorkeeper::Application.all.find do |app|
                              app.uid == params[:client_id]
                            end
  end

  def whitelisted_client_uri
    @whitelisted_client_uri ||= URI.parse(whitelisted_client.redirect_uri)
  end

  def whitelisted_client_login_uri
    if params[:login_path]
      return URI.join(whitelisted_client_uri, params[:login_path])
    end
    URI.join(whitelisted_client_uri, "/login")
  end

  def whitelisted_redirect_to_uri
    unescaped_redirect_to
  end

  def return_uri
    @return_uri ||= URI.parse(params[:return_uri])
  end

  def return_uri_base
    URI.join(return_uri, "/")
  end

  def whitelisted_client_uri_base
    URI.join(whitelisted_client_uri, "/")
  end

  def return_uri_validated?
    whitelisted_client && whitelisted_client_uri_base.eql?(return_uri_base)
  end

  def redirect_to_uri_is_valid?
    return false if params[:redirect_to].nil?
    redirect_to_uri_base.eql? original_url_base
  end

  def redirect_to_uri_base
    URI.join(URI.parse(unescaped_redirect_to), "/")
  end

  def original_url_base
    URI.join(URI.parse(request.original_url), "/")
  end

  def unescaped_redirect_to
    CGI::unescape(params[:redirect_to])
  end

end
