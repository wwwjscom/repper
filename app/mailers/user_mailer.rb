class UserMailer < ActionMailer::Base
  default from: "myrepper@gmail.com"
  default bcc: "myrepper@gmail.com"
  
  def welcome_email(user)
    @user = user
    @login_url = login_url
    mail(:to => user.email, :subject => "Welcome to Repper")
  end
end
