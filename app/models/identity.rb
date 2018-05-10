class Identity < ActiveRecord::Base
  VALID_PROVIDERS = Devise.omniauth_providers.map(&:to_s)

  belongs_to :user

  # Must have a uid, provider and properties
  validates :uid, presence: true
  validates :provider, presence: true
  # Properties is an Hstore column type
  validates :properties, presence: true

  # Must have a unique uid per provider/user
  validates :uid, uniqueness: { scope: [:user_id, :provider] }

  # Must have a valid provider
  validates :provider, inclusion: { in: VALID_PROVIDERS }

  # Properties is a NESTED Hstore column type now (no longer string values)
  serialize :properties, ActiveRecord::Coders::NestedHstore

end
