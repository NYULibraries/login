# User factory
FactoryBot.define do
  factory :user do
    username { 'developer' }
    email { 'developer@example.com' }
    institution_code { 'NYU' }
    current_sign_in_at { Time.now }
    admin { false }
    provider { "twitter" }
    last_sign_in_at { Time.now }

    trait :twitter do
      provider { "twitter" }
    end

    trait :nyu_shibboleth do
      provider { "nyu_shibboleth" }
    end

    trait :aleph do
      provider { "aleph" }
    end

    trait :new_school_ldap do
      provider { "new_school_ldap" }
    end


    factory :twitter_user, traits: [:twitter]
    factory :nyu_shibboleth_user, traits: [:nyu_shibboleth]
    factory :aleph_user, traits: [:aleph]
    factory :new_school_ldap_user, traits: [:new_school_ldap]

    after(:build) do |user|
      if user.omniauth_hash_map.blank?
        user.omniauth_hash_map = authhash_map(user.provider)
      end
    end
  end

  factory :admin, class: 'User' do
    username { 'admin' }
    email { 'admin@example.com' }
    institution_code { 'NYU' }
    provider { "twitter" }
    current_sign_in_at { Time.now }
    last_sign_in_at { Time.now }
    admin { true }
    after(:build) do |user|
      if user.omniauth_hash_map.blank?
        user.omniauth_hash_map = authhash_map(user.provider)
      end
    end
  end

  factory :ny_undergraduate_user, class: 'User' do
    username { 'undergrad' }
    email { 'undergrad@example.org' }
    institution_code { 'NYU' }
    current_sign_in_at { Time.now }
    admin { false }
    provider { "nyu_shibboleth" }
    last_sign_in_at { Time.now }

    identities { build_list :ny_undergraduate_aleph_identity, 1 }
  end

  factory :ny_graduate_user, class: 'User' do
    username { 'grad' }
    email { 'grad@example.org' }
    institution_code { 'NYU' }
    current_sign_in_at { Time.now }
    admin { false }
    provider { "nyu_shibboleth" }
    last_sign_in_at { Time.now }

    identities { build_list :ny_graduate_aleph_identity, 1 }
  end
end
