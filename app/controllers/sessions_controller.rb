class SessionsController < ApplicationController
  # for regular users
  def user_create
    user = User.find_by(email: params[:email])
  
    if user && user.authenticate(params[:password])
      if user.verified?
        token = encode_token(user.id, user.email, user.password)
        render json: {
          message: "#{user.firstName} successfully logged in",
          data: { uid: user.id, token: token },
          
        }, status: :ok
      else
        render json: {
          message: "User is not verified",
          
        },status: :unprocessable_entity
      end
    else
      render json: {
        message: "Invalid email or password",        
      }, status: :unprocessable_entity
    end
  end
  

  #logout buttons
  def destroy
    session[:user_id] = nil
    session[:farmer_id] = nil
    render json: { message: "Logged out" }
  end
end
