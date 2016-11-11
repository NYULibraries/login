# app/views/layouts/application.rb
module LayoutsHelper
  # Add Login to the breadcrumbs
  def breadcrumbs
    breadcrumbs = []
    if breadcrumbs.empty?
      breadcrumbs << link_to(institution_views["breadcrumbs"]["title"], institution_views["breadcrumbs"]["url"])
      breadcrumbs << link_to_unless(login_path(current_institution.code.downcase) == request.path, "Login", login_path(current_institution.code.downcase))
    end
  end

  # Override to only link to logout
  def login(params={})
    params.merge!({institution: current_institution.code.downcase}) if current_institution
    link_to_logout(params) if current_user
  end
end
