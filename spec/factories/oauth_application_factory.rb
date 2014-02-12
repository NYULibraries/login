# Doorkeeper::Application factory
FactoryGirl.define do
  factory :oauth_application, class: Doorkeeper::Application do
    sequence(:name) { |n| "App #{n}" }
    sequence(:redirect_uri) { |n| "https://app#{n}.dev/users/auth/nyulibraries/callback" }
  end
end
