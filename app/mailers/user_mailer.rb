class UserMailer < ApplicationMailer
  default from: 'stockup.mailer@gmail.com'
  layout 'mailer'

  def send_welcome_email(user)
    @user = user
    @url = 'https://stockup-trading.herokuapp.com/'
    mail(to: @user.email, subject: 'Welcome!')
  end

  def send_pending_broker_email(user)
    @user = user
    @url = 'https://stockup-trading.herokuapp.com/'
    mail(to: @user.email, subject: 'Pending: Broker Status')
  end

  def send_confirmation_broker_email(user)
    @user = user
    @url = 'https://stockup-trading.herokuapp.com/'
    mail(to: @user.email, subject: 'Broker Confirmation')
  end
end
