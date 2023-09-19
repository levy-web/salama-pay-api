class User < ApplicationRecord
    has_secure_password
    has_one :account
    has_many :sent_transactions, class_name: 'Transaction', foreign_key: 'user_id'
    has_many :received_transactions, class_name: 'Transaction', foreign_key: 'opposite_user_id'
end
