class UserMailer < ApplicationMailer
  def send_verification_code(user)
    @user = user
    mail(to: @user.email, subject: "Salama Verification Code")
  end

  def send_email(email)
    @transaction_id = email.transaction_id
    @issue_details = email.issue_details
    @dispute_details = email.dispute_details

    mail(to: "recipient@gmail.com", subject: "New Help Request") do |format|
      format.text { render plain: "This is the plain text body of the email." }
    end
  end
end
