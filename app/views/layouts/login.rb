# app/views/layouts/application.rb
module Views
  module Layouts
    class Login < ActionView::Mustache
      # Add Login to the breadcrumbs
      def breadcrumbs
        super << "Login"
      end
    end
  end
end
