class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Validations
  validates :email, presence: true,
                    uniqueness: true
  validates :role,  presence: true

  # Role Inheritance using CanCanCan
  ROLES = %w[buyer broker admin].freeze

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end
end
