module AuthTypeHelper

  def auth_type_with_institution
    return "#{params["auth_type"]}.#{params["institution"]}" if ["nyush","nyuad"].include?(params["institution"])
    return "#{params["auth_type"]}"
  end

end
