class EmailsController < ApplicationController
  def send_email
    email = Email.new(email_params)

    if email.save
      begin
        # Send the email using UserMailer
        UserMailer.send_email(email).deliver_now
        render json: { message: "Email sent successfully" }, status: :ok
      rescue StandardError => e
        # Handle email sending error
        logger.error("Error sending email: #{e.message}")
        render json: { errors: ["Error sending email"] }, status: :unprocessable_entity
      end
    else
      # There are validation errors. Return them in the response.
      render json: { errors: email.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def email_params
    # Use strong parameters to permit the necessary attributes
    params.permit(:transaction_id, :issue_details, :dispute_details)
  end
end
