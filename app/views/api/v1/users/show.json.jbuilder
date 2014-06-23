json.extract! @user, :email
json.identities @user.identities.first do |identity|
  json.properties identity.properties
end
