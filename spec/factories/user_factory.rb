# User factory
FactoryGirl.define do
  factory :user do
    username 'developer'
    email 'developer@example.com'
    institution_code 'NYU'
    provider "twitter"
    current_sign_in_at Time.now
    admin false
    after(:build) { |user| user.class.skip_callback(:create, :after, :create_identity_from_omniauth_hash) }
  end

  factory :admin, class: User do
    username 'admin'
    email 'admin@example.com'
    institution_code 'NYU'
    provider "facebook"
    current_sign_in_at Time.now
    admin true
    after(:build) { |user| user.class.skip_callback(:create, :after, :create_identity_from_omniauth_hash) }
  end
end
