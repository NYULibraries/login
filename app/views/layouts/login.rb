# app/views/layouts/application.rb
module Views
  module Layouts
    class Login < ActionView::Mustache
      # Add Login to the breadcrumbs
      def breadcrumbs
        breadcrumbs = []
        if breadcrumbs.empty?
          breadcrumbs << link_to(views["breadcrumbs"]["title"], views["breadcrumbs"]["url"])
          breadcrumbs << "Login"
        end
      end

      # Override to only link to logout
      def login(params={})
        link_to_logout(params) if current_user
      end
    end
  end
end
