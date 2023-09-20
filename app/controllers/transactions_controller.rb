class TransactionsController < ApplicationController
  before_action :find_users_and_escrow, only: [:create]

  def index
    render json: Transaction.all
  end

  def create
    role = Transaction.roles.key(transaction_params[:role])

    if role.nil?
      render json: { error: 'Invalid role' }, status: :unprocessable_entity
      return
    end

    transaction = create_transaction(role)
    byebug

    if transaction.save
      update_account_balances(transaction) if role == 'BUYER'
      render json: transaction
    else
      render json: { error: 'Failed to create transaction' }, status: :unprocessable_entity
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:user_id, :opposite_user_id, :amount, :role)
  end

  def find_users_and_escrow
    @user = User.find_by(id: transaction_params[:user_id])
    @opposite_user = User.find_by(id: transaction_params[:opposite_user_id])
    @escrow = EscrowAccount.find_by(id: 1)
  end

  def create_transaction(role)
    sender = nil
    receiver = nil
  
    if role == 'BUYER'
      sender = @user
      receiver = @opposite_user
    elsif role == 'SELLER'
      sender = @opposite_user
      receiver = @user
    else
      render json: { error: 'Invalid role' }, status: :unprocessable_entity
      return
    end

    byebug

    if role == 'SELLER'
      PendingSellerTransaction.new(
        user: sender,
        opposite_user: receiver,
        amount: transaction_params[:amount],
        escrow_account: @escrow,
        status: :PENDING,
        buyer_confirmation: :NOT_CONFIRMED
      )
    else
      Transaction.new(
        user: sender,
        opposite_user: receiver,
        amount: transaction_params[:amount],
        escrow_account: @escrow,
        status: :PENDING,
        role: role
      )
    end
  end

  def update_account_balances(transaction)
    @user.account.subtract_from_personal_account_balance(transaction.amount)
  end
end
