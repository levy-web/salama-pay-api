class Account < ApplicationRecord
    belongs_to :user

    def subtract_from_personal_account_balance(amount)
        self.balance -= amount
        save
    end

    def add_to_personal_account_balance(amount)
        self.balance += amount
        save
    end
end
