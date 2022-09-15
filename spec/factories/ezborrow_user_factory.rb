FactoryBot.define do
  factory :ezborrow_user, class: 'User' do
    username { 'ezborrow_developer' }
    email { 'ezborrow_developer@example.com' }
    institution_code { 'NYU' }
    current_sign_in_at { Time.now }
    admin { false }
    provider { "aleph" }
    last_sign_in_at { Time.now }
  end
end
