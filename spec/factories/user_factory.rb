# User factory
FactoryGirl.define do
  factory :user do
    username 'developer'
    email 'developer@example.com'
    institution_code 'NYU'
    provider "twitter"
    current_sign_in_at Time.now
    admin false
    after(:build) {|user| user.omniauth_hash_map = authhash_map(user.provider) unless user.omniauth_hash_map.present? }
  end

  factory :admin, class: User do
    username 'admin'
    email 'admin@example.com'
    institution_code 'NYU'
    provider "facebook"
    current_sign_in_at Time.now
    admin true
    after(:build) {|user| user.omniauth_hash_map = authhash_map(user.provider) unless user.omniauth_hash_map.present? }
  end

end
