# User factory
FactoryGirl.define do
  factory :user do
    username 'developer'
    email 'developer@example.com'
    institution_code 'NYU'
    provider "twitter"
    current_sign_in_at Time.now
    admin false
  end

  factory :nyu_shibboleth_user, class: User do
    username 'developer'
    email 'developer@example.com'
    institution_code 'NYU'
    provider "nyu_shibboleth"
    current_sign_in_at Time.now
    admin false
  end

  factory :new_school_ldap_user, class: User do
    username 'developer'
    email 'developer@example.com'
    institution_code 'NYU'
    provider "new_school_ldap"
    current_sign_in_at Time.now
    admin false
  end

  factory :facebook_user, class: User do
    username 'developer'
    email 'developer@example.com'
    institution_code 'NYU'
    provider "facebook"
    current_sign_in_at Time.now
    admin false
  end

  factory :twitter_user, class: User do
    username 'developer'
    email 'developer@example.com'
    institution_code 'NYU'
    provider "twitter"
    current_sign_in_at Time.now
    admin false
  end

  factory :aleph_user, class: User do
    username 'developer'
    email 'developer@example.com'
    institution_code 'NYU'
    provider "aleph"
    current_sign_in_at Time.now
    admin false
  end

  factory :admin, class: User do
    username 'admin'
    email 'admin@example.com'
    institution_code 'NYU'
    provider "facebook"
    current_sign_in_at Time.now
    admin true
  end
end
