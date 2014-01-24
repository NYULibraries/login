# A user must have a unique username
# and a unique and valid email address
class User < ActiveRecord::Base
  # Available devise modules are:
  # :database_authenticatable, :registerable,
  # :recoverable, :rememberable, :trackable, :validatable
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :timeoutable, :trackable, :validatable#, :token_authenticatable

  # A user can have many identities
  has_many :identities, :dependent => :destroy

  # Must have a unique username
  validates_presence_of   :username
  validates_uniqueness_of :username

  # Override Devise::Models::Validatable#password_required?
  # since we don't have passwords and therefore can't
  # require them.
  def password_required?
    false
  end

  # We want to leverage email validations via the
  # Devise::Models::Validatable module but not password
  # validations. Devise assumes a password column in the DB.
  # Since we don't have one, this is a dummy password method
  # for password length validation.
  def password; end
end
