class User < ApplicationRecord
  has_many :user_stocks, dependent: :destroy
  has_many :stocks, through: :user_stocks
  has_many :orders, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  after_create :register_as_broker
  after_create :send_admin_mail
  after_update :send_broker_confirmation

  # broker_status
  enum broker_status: { application_pending: 0, pending_approval: 1, approved: 2 }

  # Validations
  validates :email, presence: true,
                    uniqueness: true
  validates :username, presence: true
  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :role, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  # Role Inheritance using CanCanCan
  ROLES = %w[buyer broker admin].freeze

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def register_as_broker
    return unless role == 'broker'

    self.role = 'buyer'
    self.broker_status = 'pending_approval'
    save!
  end

  def send_admin_mail
    if broker_status == 'pending_approval'
      UserMailer.send_pending_broker_email(self).deliver_later
    else
      UserMailer.send_welcome_email(self).deliver_later
    end
  end

  def send_broker_confirmation
    return unless broker_status == 'approved'

    UserMailer.send_confirmation_broker_email(self).deliver_later

    # Self assigns broker role
    return unless role == 'buyer'

    self.role = 'broker'
    save!
  end
end
