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
        "N Number" => "nyuidn",
        "Street Address" => "street_address",
        "City" => "city",
        "State" => "state",
        "Postal Code" => "postal_code",
      }
    end
  end
end
