module LoginFeatures
  module ApiAttributes
    def map_title_to_field(title)
      field_titles[title]
    end

    def field_titles
      {
        "NetID" => "uid",
        "Given Name" => "first_name",
        "Surname" => "last_name",
        "N Number" => "nyuidn"
      }
    end
  end
end
