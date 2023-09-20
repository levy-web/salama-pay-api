class SessionsController < ApplicationController
  # for regular users
  def user_create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      token = encode_token(user.id, user.email, user.password)
      byebug
      # token = JWT.encode({user_id: user.id, email:user.email}, ENV['task_train_key'], 'HS256')
      render json: {message:"#{user.firstName} succesfully logged in", data:{user:user,token:token}, status: :ok}
    else
      render json: {message:"user failed logged in", data: {error: 'Invalid email or password'}}, status: :unprocessable_entity
    end
  end

  #logout buttons
  def destroy
    session[:user_id] = nil
    session[:farmer_id] = nil
    render json: { message: "Logged out" }
  end
end
