# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
username = 'admin'
if Rails.env.development? and User.find_by_username(username).nil?
  user = User.create!({
    username: username,
    email: 'dev.eloper@library.edu',
    institution_code: :NYU,
    admin: true,
    provider: "nyu_shibboleth"
  })
  user.identities.create!({
    provider: "aleph",
    uid: "USERNAME",
    properties: {
      uid: "USERNAME",
      name: "USERNAME, TEST-RECORD",
      nickname: "USERNAME",
      email: "username@library.edu",
    }
  })
  user.save!  
end

admin_client_id = ENV['SEED_ADMIN_CLIENT_ID']
admin_client_secret = ENV['SEED_ADMIN_CLIENT_SECRET']
if Rails.env.development? && admin_client_id && admin_client_secret
  app = Doorkeeper::Application.create!({
    name: "Seed Admin App",
    uid: admin_client_id,
    secret: admin_client_secret,
    redirect_uri: "urn:ietf:wg:oauth:2.0:oob",
    scopes: ["admin"],
    confidential: true,
  })
end
