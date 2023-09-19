class EscrowAccount < ApplicationRecord
    has_many :transactions, class_name: 'Transaction', foreign_key: 'escrow_account_id'
end
