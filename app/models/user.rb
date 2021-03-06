# A user must have a unique username
# and a unique and valid email address
class User < ApplicationRecord
  module ClassMethods
    Devise::Models.config(self, :email_regexp)
  end

  # Use Devise::Models::Authenticatable::ClassMethods#find_for_authentication
  # to take advantage of the Devise case_insensitive_keys and treat USER and user as the same username
  def self.find_for_authentication_or_initialize_by(attrs)
    find_for_authentication(attrs) || find_or_initialize_by(attrs)
  end

  self.extend ClassMethods

  VALID_INSTITUTION_CODES = Institutions.institutions.keys.map(&:to_s)

  attr_reader :omniauth_hash_map
  attr_reader :auth_groups

  scope :non_admin, -> { where(admin: false) }
  scope :admin, -> { where(admin: true) }
  scope :inactive, -> { where("last_sign_in_at IS NULL OR last_sign_in_at < ?", 1.year.ago) }

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

  def auth_groups
    auth_groups = Login::AuthGroups.new(self)
    @auth_groups = auth_groups.auth_groups
  end

  def firstname
    @firstname ||= aleph_identity&.properties.try(:[], "first_name")
  end

  def lastname
    @lastname ||= aleph_identity&.properties.try(:[], "last_name")
  end

  def aleph_identity
    @aleph_identity ||= identities.where(provider: "aleph").first
  end

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
    aleph_patron = begin
      Login::Aleph::PatronLoader.new(omniauth_hash_map.nyuidn).patron
    rescue Exception => e
      Raven.capture_exception(e)
      nil
    end
    # Start with the omniauth hash to create the identity if user logged in with Aleph
    identity.properties.merge!(omniauth_hash_map.properties) if omniauth_hash_map.provider == 'aleph'
    # If the patron was also found from the loader, update the properties to those
    # since they may be more up to date from the flat file
    identity.properties.merge!(aleph_patron.attributes) if aleph_patron.present?
    identity.updated_at = Time.now
    identity.save
  end


  Devise.omniauth_providers.each do |provider|
    define_method(:"#{provider}_properties") do
      HashWithIndifferentAccess.new(identities.find_by(provider: provider)&.properties)
    end
  end

  # Update identity assoc from OmniAuth hash
  def create_or_update_identity_from_omniauth_hash
    # Create or update an identity from the attributes mapped in the mapper
    identity = identities.find_or_initialize_by(uid: omniauth_hash_map.uid, provider: omniauth_hash_map.provider)
    identity.properties.merge!(omniauth_hash_map.properties)
    identity.save
  end
end
