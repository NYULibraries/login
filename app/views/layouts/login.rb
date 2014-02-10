# app/views/layouts/application.rb
module Views
  module Layouts
    class Login < ActionView::Mustache
      # Add Login to the breadcrumbs
      def breadcrumbs
        super << "Login"
      end

      # Override to only link to logout
      def login(params={})
        link_to_logout(params) if current_user
      end
    end
  end
end
