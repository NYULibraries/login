ApplicationController.class_eval do
  skip_before_filter :check_passive_shibboleth_and_sign_in, if: -> { Rails.env.development? }
end
