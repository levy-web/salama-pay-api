class ApplicationController < ActionController::API

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

end
