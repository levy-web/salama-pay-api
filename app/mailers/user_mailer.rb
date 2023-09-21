class UserMailer < ApplicationMailer
    def send_verification_code(user)
        @user = user
        mail(to: @user.email, subject: 'Salama Verification Code')
    end
end
