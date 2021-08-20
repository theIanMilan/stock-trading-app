class UserMailer < ApplicationMailer
  default from: 'stockup.mailer@gmail.com'
  layout 'mailer'

  def send_welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome!')
  end
end
