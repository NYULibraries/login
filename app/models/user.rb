# A user must have a unique username
# and a unique and valid email address
class User < ActiveRecord::Base
  module ClassMethods
    Devise::Models.config(self, :email_regexp)
  end
  self.extend ClassMethods

  VALID_INSTITUTION_CODES = Institutions.institutions.keys.map(&:to_s)

  attr_reader :omniauth_hash_map

  # Create an identity from Aleph if the user is in Aleph
  after_save :create_or_update_aleph_identity, if: -> { omniauth_hash_map.present? && omniauth_hash_map.nyuidn.present? }
  # Create an identity from the OmniAuth::AuthHash after the user is created
  after_save :create_or_update_identity_from_omniauth_hash, if: -> { omniauth_hash_map.present? }, unless: -> { provider == 'aleph' }

  # Available devise modules are:
  # :database_authenticatable, :registerable,
  # :recoverable, :rememberable, :trackable, :validatable
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :timeoutable, :trackable#, :token_authenticatable

  # A user can have many identities
  has_many :identities, dependent: :destroy

  # Must have a username
  validates_presence_of :username
  # Must have a unique uid per provider
  validates :username, uniqueness: { scope: :provider }

  # Must have a valid identity provider
  validates :provider, inclusion: { in: Identity::VALID_PROVIDERS }

  # Must have a valid institution code
  validates :institution_code, inclusion: { in: VALID_INSTITUTION_CODES },
    allow_blank: true

  # Attr writer for omniauth_hash_map
  def omniauth_hash_map=(omniauth_hash_map)
    raise ArgumentError unless omniauth_hash_map.is_a? Login::OmniAuthHash::Mapper
    @omniauth_hash_map = omniauth_hash_map
  end

  # Make pretty URLs for users based on their usernames
  def to_param; username end

  # Resolve the institution based on
  def institution
    @institution ||= Institutions.institutions[institution_code.to_sym]
  end

  # Create Aleph identity specifically for each other identity,
  # if the patron can be found in Aleph
  def create_or_update_aleph_identity
    identity = identities.find_or_initialize_by(uid: omniauth_hash_map.nyuidn, provider: "aleph")
    if identity.expired?
      aleph_patron = Login::Aleph::PatronLoader.new(omniauth_hash_map.nyuidn).patron
      # Start with the omniauth hash to create the identity if user logged in with Aleph
      identity.properties.merge!(omniauth_hash_map.properties) if omniauth_hash_map.provider == 'aleph'
      # If the patron was also found from the loader, update the properties to those
      # since they may be more up to date from the flat file
      identity.properties.merge!(aleph_patron.attributes) if aleph_patron.present?
      identity.save
    end
  end

  # Update identity assoc from OmniAuth hash if it's expired
  def create_or_update_identity_from_omniauth_hash
    # Create or update an identity from the attributes mapped in the mapper
    identity = identities.find_or_initialize_by(uid: omniauth_hash_map.uid, provider: omniauth_hash_map.provider)
    if identity.expired?
      identity.properties.merge!(omniauth_hash_map.properties)
      identity.save
    end
  end
end
