class Identity < ActiveRecord::Base
  VALID_PROVIDERS = %w(nyu_shibboleth ns_ldap aleph twitter facebook)

  belongs_to :user

  # Must have a uid, provider and properties
  validates :uid, presence: true
  validates :provider, presence: true
  validates :properties, presence: true

  # Must have a unique uid per provider
  validates :uid, uniqueness: { scope: :provider }

  # Must have a valid provider
  validates :provider, inclusion: { in: VALID_PROVIDERS }
end
