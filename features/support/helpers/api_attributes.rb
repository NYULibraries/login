module LoginFeatures
  module ApiAttributes
    def map_title_to_field(title)
       field_titles[title] or title.parameterize.underscore
    end

    def field_titles
      {
        "NetID" => "uid",
        "Aleph ID" => "uid",
        "Given Name" => "first_name",
        "Surname" => "last_name",
        "Entitlement" => "entitlement",
        "N Number" => "nyuidn"
      }
    end
  end
end
