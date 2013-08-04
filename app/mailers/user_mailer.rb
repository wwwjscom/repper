class UserMailer < ActionMailer::Base
  default from: "repperapp@gmail.com"
  default bcc: "repperapp@gmail.com"
  default reply_to: 'support@repper.zendesk.com'
  
  def welcome_email(user)
    @user = user
    @login_url = login_url
    mail(:to => user.email, :subject => "Welcome to Repper")
  end
end
