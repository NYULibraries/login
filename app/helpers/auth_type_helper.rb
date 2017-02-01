module AuthTypeHelper

  def auth_type_with_institution
    return "#{params["auth_type"]}.#{params["institution"]}" if ["nyush","nyuad"].include?(params["institution"])
    return "#{params["auth_type"]}"
  end

  # Return a help-block for the password field if the institution has a
  # password_help_text translation
  #
  #   password_field_help_text # <p class="help-block">Case-sensitive</p>
  def password_field_help_text
    help_text = t("application.#{auth_type_with_institution}.password_help_text", raise: true)
    content_tag(:p, help_text, class: 'help-block') if help_text
  rescue I18n::MissingTranslationData => e
    nil
  end

end
