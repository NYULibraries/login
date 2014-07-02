module LoginFeatures
  module ApiAttributes
    def map_field_to_title(field)
      field_titles[field]
    end

    def field_titles
      {
        "NetID" => "uid",
        "Given Name" => "first_name",
        "Surname" => "last_name",
        "Entitlement" => "entitlement",
        "N Number" => "nyuidn"
      }
    end
  end
end
