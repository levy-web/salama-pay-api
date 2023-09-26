class ApplicationController < ActionController::API

    include ActionController::Cookies

    rescue_from StandardError, with: :standard_error

    def app_response(message: 'success', status: 200, data: nil)
        render json: {
            message: message,
            data: data
        }, status: status
    end

    def encode_token(uid, email, password)
        payload = {
            data:{
                uid: uid,
                email: email,
                secret: password
            },
            exp: Time.now.to_i + (0.5*3600)
        }
        JWT.encode(payload, ENV['salama_key'], 'HS256')
    end

    def decode(token)
        JWT.decode(token, ENV['salama_key'], true, { algorithm: 'HS256' })
    end

    # verify authorization headers
    def verify_auth
        auth_headers = request.headers['Authorization']
        
        if !auth_headers
            app_response(message: 'failed', status: 401, data: { info: 'Your request is not authorized.' })
        else
            
            token = auth_headers.split(' ')[1]
            
            save_user_id(token)
        end
    end

    def save_user_id(token)

        @loggedin_user = {uid:decode(token)[0]["data"]["uid"].to_i, user_type:decode(token)[0]["data"]["email"]}
        
        
  
    end


    private 

    def standard_error(exception)
        app_response(message: 'failed', data: { info: exception.message }, status: :unprocessable_entity)
    end

end
