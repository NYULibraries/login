module LoginFeatures
  module ApiAttributes
    def map_title_to_field(title)
      field_titles[title]
    end

    def field_titles
      {
        "NetID" => "uid",
        "Aleph ID" => "uid",
        "Patron Status" => "z305_bor_status",
        "Patron Type" => "z305_bor_type",
        "ILL Permission" => "z305_photo_permission",
        "PLIF Status" => "z303_birthplace",
        "Given Name" => "first_name",
        "Surname" => "last_name",
        "Entitlement" => "entitlement",
        "N Number" => "nyuidn"
      }
    end
  end
end
