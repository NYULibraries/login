module LoginFeatures
  module PassiveShibboleth
    # We temporarily disable the passive url check by redirecting it to "/".
    # This keeps the integration and function of the app the same but forces
    # to keep all redirects local. Win win.
    def ignore_passive_shibboleth
      #UsersController.any_instance.should_receive(:passive_shibboleth_url).and_return("/")
    end
  end
end
