class MpesaQueryJob < ApplicationJob
  queue_as :default

  def perform(checkout_request_id, phone_number, access_token)
    MpesaTransaction.transaction do
      byebug

      response = perform_stk_query(checkout_request_id, access_token)
      byebug
      

      # Call the process_stk_query_response method to process the response
      process_stk_query_response(response, checkout_request_id, phone_number)
    end
  end

  private

  def perform_stk_query(checkout_request_id, access_token)
    url = "https://sandbox.safaricom.co.ke/mpesa/stkpushquery/v1/query"
    timestamp = "#{Time.now.strftime "%Y%m%d%H%M%S"}"
    business_short_code = ENV["MPESA_SHORTCODE"]
    password = Base64.strict_encode64("#{business_short_code}#{ENV["MPESA_PASSKEY"]}#{timestamp}")
    payload = {
    'BusinessShortCode': business_short_code,
    'Password': password,
    'Timestamp': timestamp,
    'CheckoutRequestID': checkout_request_id
    }.to_json

    headers = {
    Content_type: 'application/json',
    Authorization: "Bearer #{access_token}"
    }

    byebug

    response = RestClient::Request.new({
    method: :post,
    url: url,
    payload: payload,
    headers: headers
    }).execute do |response, request|
    case response.code
        when 500
            [ :error, JSON.parse(response.to_str) ]
        when 400
            [ :error, JSON.parse(response.to_str) ]
        when 200
            [ :success, JSON.parse(response.to_str) ]
        else
            fail "Invalid response #{response.to_str} received."
        end
    end

    # process_stk_query_response(response, checkout_request_id, phone_number)

    response
  end

  def process_stk_query_response(response, checkout_request_id, phone_number)
    byebug
    case response[0]
    when :error
      byebug
      # Handle the error case, perhaps by notifying the user or logging the error
      # render json: { error: response[1] }, status: :unprocessable_entity
      Rails.logger.info(error: response[1])
    when :success
      byebug
      result_code = response[1]["ResultCode"]

      if result_code == "0"
        # The transaction was successful, check and update the transaction state
        mpesa_transaction = MpesaTransaction.find_by(checkout_request_id: checkout_request_id)

        if mpesa_transaction && mpesa_transaction.status == 'pending'
          mpesa_transaction.update(status: 'completed')

          # Retrieve the user by phone number (You need to define a User model and adapt this part)
          user = User.find_by(phone: "+#{phone_number}")
          byebug

          if user
            # Credit the user's account
            user.account.add_to_personal_account_balance(mpesa_transaction.amount) #add amount to user
            # render json: { message: "Payment successful. User balance updated." }, status: :ok
            Rails.logger.info("Payment successful. User balance updated.")
          else
            # render json: { message: "User not found." }, status: :unprocessable_entity
            Rails.logger.info("User not found.")

          end
        else
          # render json: { message: "Payment already processed." }, status: :unprocessable_entity
          Rails.logger.info("Payment already processed.")
        end
      else
        # Handle other result codes indicating a failed transaction
        # render json: { message: "Payment not successful. ResultCode: #{result_code}" }, status: :unprocessable_entity
        Rails.logger.info("Payment not successful. ResultCode: #{result_code}")

      end
    end
  end
  
end