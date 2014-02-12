module DoorkeeperMacros
  def set_resource_owner
    let(:resource_owner) { find_or_create_user }
  end
  private :set_resource_owner

  def set_oauth_application
    let(:oauth_application) { create(:oauth_application) }
  end
  private :set_oauth_application

  def set_code
    let(:code) do
      get :new, client_id: application.uid,
        redirect_uri: application.redirect_uri, response_type: "code"
      response.location.gsub("#{application.redirect_uri}?code=", "")
    end
  end

  def set_access_token
    set_resource_owner
    set_oauth_application
    let(:access_token) do
      authorized_token = oauth_application.authorized_tokens.
        create(resource_owner_id: resource_owner.id)
      authorized_token.token
    end
  end

  def set_expired_access_token
    set_resource_owner
    set_oauth_application
    let(:expired_access_token) do
      expired_authorized_token = oauth_application.authorized_tokens.
        create(resource_owner_id: resource_owner.id, expires_in: -1)
      expired_authorized_token.token
    end
  end

  def set_revoked_access_token
    set_resource_owner
    set_oauth_application
    let(:revoked_access_token) do
      revoked_authorized_token = oauth_application.authorized_tokens.
        create(resource_owner_id: resource_owner.id)
      revoked_authorized_token.revoke
      revoked_authorized_token.token
    end
  end
end
