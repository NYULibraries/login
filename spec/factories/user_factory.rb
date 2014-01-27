# User factory
FactoryGirl.define do
  factory :user do
    username 'developer'
    email 'developer@example.com'
    institution_code 'NYU'
  end
end
