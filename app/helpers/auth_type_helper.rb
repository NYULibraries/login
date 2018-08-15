module AuthTypeHelper

  def auth_type_with_institution
    suffix = ["nyush", "nyuad"].include?(params[:institution]) ? ".#{params[:institution]}" : ""
    "#{params[:auth_type]}#{suffix}"
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
