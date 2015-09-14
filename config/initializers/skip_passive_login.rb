ApplicationController.class_eval do
  skip_before_filter :shibboleth_passive_login_check, if: -> { Rails.env.development? }
end
