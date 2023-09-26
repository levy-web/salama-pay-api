class TransactionsController < ApplicationController
  before_action :verify_auth, only: %i[index confirm_transaction complete_transaction create destroy update]
  before_action :find_users_and_escrow, only: [:create]

  def index
    @user = User.find_by(id: @loggedin_user[:uid])
    
    render json: {data: {sent_transactions: @user.sent_transactions, received_transactions: @user.received_transactions, pending_buyer_transactions: @user.pending_buyer_transactions, pending_seller_transactions: @user.pending_seller_transactions}}
  end

  def create
    role = Transaction.roles.key(transaction_params[:role])
    userIn = User.find_by(id: @loggedin_user[:uid])
    

    if role.nil?
      render json: { message: 'Invalid role' }, status: :unprocessable_entity
      return
    end

    transaction = create_transaction(role)
    

    

    if transaction.amount > userIn.account.balance && role == 'BUYER'
      render json: { message: 'Insufficient funds In your account' }, status: :unprocessable_entity
      return
    end

    if transaction.save
      if role == 'BUYER'
        update_account_balances(transaction)
        render json: { transaction:transaction, message: 'Transaction created succesfully and funds are pending in sellers account awaiting your confirmation.' }, status: :ok
      elsif role == 'SELLER'
        render json: { transaction:transaction, message: 'Request has been successfully sent to the buyer for confirmation.' }, status: :ok
      end
    else
      if role == 'BUYER'
        render json: { message: 'Transaction creation failed. Please try again.' }, status: :unprocessable_entity
      elsif role == 'SELLER'
        render json: { message: 'Failed to send request. Please try again.' }, status: :unprocessable_entity
      end
    end
  end

  def confirm_transaction
    pending_transaction = PendingSellerTransaction.find(params[:id])
    userIn = User.find_by(id: @loggedin_user[:uid])

    if userIn.id != pending_transaction.user.id
      render json: { message: 'Unauthorized' }, status: :unauthorized
      return
    end
  
    if pending_transaction.buyer_confirmation == 'CONFIRMED'
      render json: { message: 'Transaction already confirmed by the buyer' }, status: :unprocessable_entity
      return
    end

    if pending_transaction.amount > userIn.account.balance
      render json: { message: 'Insufficient funds In your account' }, status: :unprocessable_entity
      return
    end
  
    pending_transaction.buyer_confirmation = 'CONFIRMED'
    
  
    # Move data to the Transaction table
    transaction = Transaction.new(
      user: pending_transaction.user,
      opposite_user: pending_transaction.opposite_user,
      amount: pending_transaction.amount,
      escrow_account: pending_transaction.escrow_account,
      status: :PENDING,
      role: 'SELLER' # Set the role to SELLER since the buyer has confirmed
    )
  
    # Use a database transaction to ensure both operations succeed or fail together
    ActiveRecord::Base.transaction do
      if pending_transaction.destroy && transaction.save
        pending_transaction.user.account.subtract_from_personal_account_balance(pending_transaction.amount)

        pending_transaction.opposite_user.held_fund.add_to_personal_held_balance(pending_transaction.amount)

        render json: {transaction:transaction, message: 'Request accepted succesfully' }
      else
        render json: { message: 'Failed to confirm transaction' }, status: :unprocessable_entity
        raise ActiveRecord::Rollback # Rollback the transaction if there's an error
      end
    end
  end

  def complete_transaction

    transaction = Transaction.find(params[:id])
    userIn = User.find_by(id: @loggedin_user[:uid])

    if userIn.id != transaction.user.id
      render json: { message: 'Unauthorized' }, status: :unauthorized
      return
    end
  
    if transaction.status != "PENDING"
      render json: { message: 'Transaction is not in a pending state' }, status: :unprocessable_entity
      return
    end
  
    if transaction.update(status: 1)
      transaction.opposite_user.held_fund.subtract_from_personal_held_balance(transaction.amount)
      transaction.opposite_user.account.add_to_personal_account_balance(transaction.amount)
      render json: { transaction:transaction, message: 'Transaction complete, funds are tranferred to sellers account' }, status: :ok
    else
      render json: { message: 'Failed to complete the transaction' }, status: :unprocessable_entity
    end
  
  end
  

  private

  def transaction_params
    params.require(:transaction).permit(:opposite_user_id, :amount, :role)
  end

  def find_users_and_escrow
    @user = User.find_by(id: @loggedin_user[:uid])
    @opposite_user = User.find_by(id: transaction_params[:opposite_user_id])
    @escrow = EscrowAccount.find_by(id: 1)
    
  end

  def create_transaction(role)
    sender = nil
    receiver = nil
  
    if role == 'BUYER'
      sender = @user
      receiver = @opposite_user
    else role == 'SELLER'
      sender = @opposite_user
      receiver = @user
    end

    

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
    
    # subtract from the buyers account 
    @user.account.subtract_from_personal_account_balance(transaction.amount)
    
    # add to sellers hold account
    @opposite_user.held_fund.add_to_personal_held_balance(transaction.amount)
    
  end
end
