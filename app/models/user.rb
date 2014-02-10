# A user must have a unique username
# and a unique and valid email address
class User < ActiveRecord::Base
  VALID_INSTITUTION_CODES = Institutions.institutions.keys.map(&:to_s)

  # Include OmniAuth::AuthHash helper methods
  include OmniAuthHashHelper

  # Create an identity from the OmniAuth::AuthHash after the user is created
  after_create :create_identity_from_omniauth_hash

  # Available devise modules are:
  # :database_authenticatable, :registerable,
  # :recoverable, :rememberable, :trackable, :validatable
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :timeoutable, :trackable, :validatable#, :token_authenticatable

  # A user can have many identities
  has_many :identities, dependent: :destroy

  # Must have a username
  validates_presence_of   :username
  # Must have a unique uid per provider
  validates :username, uniqueness: { scope: :provider }

  # Must have a valid identity provider
  validates :provider, inclusion: { in: Identity::VALID_PROVIDERS }

  # Must have a valid institution code
  validates :institution_code, inclusion: { in: VALID_INSTITUTION_CODES },
    allow_blank: true

  # Make pretty URLs for users based on their usernames
  def to_param; username end

  # Override Devise::Models::Validatable#password_required?
  # since we don't have passwords and therefore can't
  # require them.
  def password_required?; false end
  protected :password_required?

  # We want to leverage email validations via the
  # Devise::Models::Validatable module but not password
  # validations. Devise assumes a password column in the DB.
  # Since we don't have one, this is a dummy password method
  # for password length validation.
  def password; end

  # Override Devise::Models::Validatable#email_required?
  # since twitter doesn't provide emails and therefore can't
  # require them.
  def email_required?; false end
  protected :email_required?

  # Resolve the institution based on 
  def institution
    @institution ||= Institutions.institutions[institution_code.to_sym]
  end

  def create_identity_from_omniauth_hash
    if omniauth_hash?
      identities.create(uid: omniauth_uid, provider: omniauth_identity_provider, properties: omniauth_properties)
    end
  end
end
