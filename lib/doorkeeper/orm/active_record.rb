# Monkey-patches out lazy loading in order to maintain comptability with FactoryBot
# See:  https://github.com/doorkeeper-gem/doorkeeper/issues/1043
#       https://github.com/doorkeeper-gem/doorkeeper/issues/913
#       https://github.com/thoughtbot/factory_bot_rails/pull/264

module Doorkeeper
  module Orm
    module ActiveRecord
      def self.initialize_models!
        require 'doorkeeper/orm/active_record/access_grant'
        require 'doorkeeper/orm/active_record/access_token'
        require 'doorkeeper/orm/active_record/application'

        if Doorkeeper.configuration.active_record_options[:establish_connection]
          [Doorkeeper::AccessGrant, Doorkeeper::AccessToken, Doorkeeper::Application].each do |c|
            c.send :establish_connection, Doorkeeper.configuration.active_record_options[:establish_connection]
          end
        end
      end

      def self.initialize_application_owner!
        require 'doorkeeper/models/concerns/ownership'

        Doorkeeper::Application.send :include, Doorkeeper::Models::Ownership
      end
    end
  end
end
