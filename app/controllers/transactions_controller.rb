class TransactionsController < ApplicationController


    def index
        render json: Transaction.all
    end


    def create
        @user = User.find_by(id: transaction_params[:user_id])
        @opposite_user = User.find_by(id: transaction_params[:opposite_user_id])
        @escrow = EscrowAccount.find_by(id: 1)
      
        role = Transaction.roles.key(transaction_params[:role])

        sender = nil
        receiver = nil
      
        if role == 'BUYER' # Compare with uppercase string
            sender = @user
            receiver = @opposite_user
          elsif role == 'SELLER' # Compare with uppercase string
            sender = @opposite_user
            receiver = @user
          else
            # Handle invalid role here (e.g., raise an error or return an error response)
          end
      
        if sender && receiver
          transaction = Transaction.new(
            user: sender,
            opposite_user: receiver,
            amount: transaction_params[:amount],
            escrow_account: @escrow,
            status: :PENDING,
            role: role
          )
          byebug
      
          if transaction.save && role == 'BUYER'
            byebug
            sender.account.subtract_from_personal_account_balance(transaction_params[:amount])
            byebug
            render json: transaction
          elsif transaction.save && role == 'SELLER'
            byebug
            render json: transaction
          else
            byebug
            # Handle errors here (e.g., return an error response)
          end
        else
          # Handle invalid role here (e.g., raise an error or return an error response)
        end
      end
      

    private

    def transaction_params
        params.require(:transaction).permit( :user_id, :opposite_user_id, :amount, :role)
    end

end
