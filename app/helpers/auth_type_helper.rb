module AuthTypeHelper

  def auth_type_with_institute
    return "#{params["auth_type"]}.#{params["institute"]}" if ["nyush","nyuad"].include?(params["institute"])
    return "#{params["auth_type"]}"
  end

end
