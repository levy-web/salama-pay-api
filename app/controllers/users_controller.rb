class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

 # POST /users
  def create
      @user = User.new(user_params)
      @user.verification_code = rand(100_000..999_999) # Generate a random 6-digit code
  
      if @user.save        
        
      # Send the verification code to the user's email (you'll need to implement this)
      UserMailer.send_verification_code(@user).deliver_now
      
      # Create a new account for the user with a balance of 0
      Account.create(user: @user, balance: 0)

      # Create a hold funds account for the user with a balance of 0
      HeldFund.create(amount: 0,user: @user)
  
      render json: {uid:@user.id, message: 'User created. Check your email for the verification code.' }, status: :created
      else
      render json: @user.errors, status: :unprocessable_entity
      end
  end

  def verify_code
    @user = User.find_by(id: params[:id])
    code = params[:verification_code]
  
    if @user && @user.verification_code == code
      # Code matches, mark the user as verified (you can customize this logic)
      @user.update(verified: true, verification_code: nil)
  
      render json: { message: 'Verification successful. You are now registered.' }
    else
      render json: { error: 'Invalid verification code.' }, status: :unprocessable_entity
    end
  end



  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.permit(:firstName, :middleName, :surname, :email, :password, :address, :phone)
    end
end