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
  user.save!
end