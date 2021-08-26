class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  after_create :send_admin_mail

  # broker_status
  enum broker_status: { application_pending: 0, pending_approval: 1, approved: 2 }

  # Role Inheritance using CanCanCan
  ROLES = %w[buyer broker admin].freeze

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

  def send_admin_mail
    UserMailer.send_welcome_email(self).deliver_later
  end
end
