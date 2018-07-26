ApplicationController.class_eval do
  skip_before_action :shibboleth_passive_login_check, if: -> { Rails.env.development? }, raise: false
end
