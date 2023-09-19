class EscrowAccount < ApplicationRecord
    has_many :transactions, class_name: 'Transaction', foreign_key: 'escrow_account_id'

    def subtract_from_escrow_account_balance(amount)
        self.balance -= amount
        save
    end

    def add_to_escrow_account_balance(amount)
        self.balance += amount
        save
    end
end
