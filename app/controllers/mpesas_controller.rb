class MpesasController < ApplicationController
    require 'rest-client'
    require 'json'
    require 'net/http'
    require 'uri'

    def stkpush
        phoneNumber = mpesa_params[:phoneNumber]
        amount = mpesa_params[:amount]
        url = "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest"
        timestamp = "#{Time.now.strftime "%Y%m%d%H%M%S"}"
        business_short_code = ENV["MPESA_SHORTCODE"]
        password = Base64.strict_encode64("#{business_short_code}#{ENV["MPESA_PASSKEY"]}#{timestamp}")
        payload = {
        'BusinessShortCode': business_short_code,
        'Password': password,
        'Timestamp': timestamp,
        'TransactionType': "CustomerPayBillOnline",
        'Amount': amount,
        'PartyA': phoneNumber,
        'PartyB': business_short_code,
        'PhoneNumber': phoneNumber,
        'CallBackURL': "#{ENV["CALLBACK_URL"]}/callback_url",
        'AccountReference': 'Codearn',
        'TransactionDesc': "Payment for Codearn premium"
        }.to_json

        headers = {
        Content_type: 'application/json',
        Authorization: "Bearer #{get_access_token}"
        }

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
        render json: response
    end

    def stkquery
        url = "https://sandbox.safaricom.co.ke/mpesa/stkpushquery/v1/query"
        timestamp = "#{Time.now.strftime "%Y%m%d%H%M%S"}"
        business_short_code = ENV["MPESA_SHORTCODE"]
        password = Base64.strict_encode64("#{business_short_code}#{ENV["MPESA_PASSKEY"]}#{timestamp}")
        payload = {
        'BusinessShortCode': business_short_code,
        'Password': password,
        'Timestamp': timestamp,
        'CheckoutRequestID': params[:checkoutRequestID]
        }.to_json

        headers = {
        Content_type: 'application/json',
        Authorization: "Bearer #{get_access_token}"
        }

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
        render json: response
    end


    private

    def generate_access_token_request
        @url = URI("https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials")
        @consumer_key = ENV['MPESA_CONSUMER_KEY']
        @consumer_secret = ENV['MPESA_CONSUMER_SECRET']
        @userpass = Base64.strict_encode64("#{@consumer_key}:#{@consumer_secret}")

        https = Net::HTTP.new(@url.host, @url.port);
        https.use_ssl = true
      
        request = Net::HTTP::Get.new(@url)
        request['Authorization'] = "Basic #{@userpass}"
      
        response = https.request(request)
        byebug
      
        # Return the response object if needed
        response
      end

    def get_access_token
        res = generate_access_token_request()
        byebug
        if res.code != '200'
          raise MpesaError.new('Unable to generate access token')
        end
        access_token = JSON.parse(res.body)["access_token"] unless res.body.empty?
        access_token
    end

    def mpesa_params
        params.permit(:phoneNumber, :amount)
    end

end
