# User factory
FactoryGirl.define do
  factory :user do
    username 'developer'
    email 'developer@example.com'
    institution_code 'NYU'
    current_sign_in_at Time.now
    admin false
    provider "twitter"
    last_sign_in_at Time.now

    trait :twitter do
      provider "twitter"
    end

    trait :facebook do
      provider "facebook"
    end

    trait :nyu_shibboleth do
      provider "nyu_shibboleth"
    end

    trait :aleph do
      provider "aleph"
    end

    trait :new_school_ldap do
      provider "new_school_ldap"
    end

    factory :twitter_user, traits: [:twitter]
    factory :facebook_user, traits: [:facebook]
    factory :nyu_shibboleth_user, traits: [:nyu_shibboleth]
    factory :aleph_user, traits: [:aleph]
    factory :new_school_ldap_user, traits: [:new_school_ldap]

    after(:build) {|user| user.omniauth_hash_map = authhash_map(user.provider) unless user.omniauth_hash_map.present? }
  end

  factory :admin, class: User do
    username 'admin'
    email 'admin@example.com'
    institution_code 'NYU'
    provider "facebook"
    current_sign_in_at Time.now
    last_sign_in_at Time.now
    admin true
    after(:build) {|user| user.omniauth_hash_map = authhash_map(user.provider) unless user.omniauth_hash_map.present? }
  end

end
