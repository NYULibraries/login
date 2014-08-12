# A user must have a unique username
# and a unique and valid email address
class User < ActiveRecord::Base
  module ClassMethods
    Devise::Models.config(self, :email_regexp)
  end
  self.extend ClassMethods

  VALID_INSTITUTION_CODES = Institutions.institutions.keys.map(&:to_s)

  attr_reader :omniauth_hash_map

  # Create an identity from the OmniAuth::AuthHash after the user is created
  after_save :create_or_update_identity_from_omniauth_hash
  # Create an identity from Aleph if the user is in Aleph
  after_save :create_or_update_aleph_identity

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

  validates_format_of :email, with: email_regexp, allow_blank: true, if: :email_changed?

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

  # Update identity assoc from OmniAuth hash if it's expired
  def create_or_update_identity_from_omniauth_hash
    # Validate OmniAuth::AuthHash representation of the hash mapper
    if omniauth_hash_map.present?
      # And create or update an identity from the attributes mapped in the mapper
      identity = identities.find_or_initialize_by(uid: omniauth_hash_map.uid, provider: omniauth_hash_map.provider)
      identity.properties = omniauth_hash_map.properties if identity.expired?
      identity.save
    end
  end

  def create_or_update_aleph_identity
    # binding.pry
    if omniauth_hash_map.present?
      identity = identities.find_or_initialize_by(uid: omniauth_hash_map.nyuidn, provider: "aleph")
      if identity.expired?
        aleph_patron = Login::Aleph::PatronLoader.new(omniauth_hash_map.nyuidn).patron
        if aleph_patron.present?
          identity.properties.merge!(aleph_patron.attributes)
          identity.save
        end
      end
    end
  end
end
