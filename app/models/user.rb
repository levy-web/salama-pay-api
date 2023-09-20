class User < ApplicationRecord
    has_secure_password
    has_one :account
    has_one :held_fund
    has_many :sent_transactions, class_name: 'Transaction', foreign_key: 'user_id'
    has_many :received_transactions, class_name: 'Transaction', foreign_key: 'opposite_user_id'
    has_many :pending_buyer_transactions, class_name: 'PendingSellerTransaction', foreign_key: 'user_id'
    has_many :pending_seller_transactions, class_name: 'PendingSellerTransaction', foreign_key: 'opposite_user_id'
end
