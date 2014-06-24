class Identity < ActiveRecord::Base
  VALID_PROVIDERS = Devise.omniauth_providers.map(&:to_s)

  attr_accessor :omniauth_hash_map

  belongs_to :user

  # Must have a uid, provider and properties
  validates :uid, presence: true
  validates :provider, presence: true
  # Properties is an Hstore column type
  validates :properties, presence: true

  # Must have a unique uid per provider
  validates :uid, uniqueness: { scope: :provider }

  # Must have a valid provider
  validates :provider, inclusion: { in: VALID_PROVIDERS }

  # Identities expire in a week's time.
  def expired?
    (updated_at.blank? || updated_at < 1.week.ago)
  end
end
