# Doorkeeper::Application factory
FactoryBot.define do
  factory :oauth_application, class: Doorkeeper::Application do
    sequence(:name) { |n| "App #{n}" }
    sequence(:redirect_uri) { |n| "https://app#{n}.dev/users/auth/nyulibraries/callback" }

    factory :oauth_app_no_redirect do
      redirect_uri { "urn:ietf:wg:oauth:2.0:oob" }
    end
  end
end
