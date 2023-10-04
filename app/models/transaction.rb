class Transaction < ApplicationRecord
    belongs_to :user
    belongs_to :opposite_user, class_name: 'User'
    belongs_to :escrow_account, class_name: 'EscrowAccount', foreign_key: 'escrow_account_id'
    has_one :contract_info, dependent: :destroy
  
    enum :status, [:PENDING, :COMPLETED, :CANCELED]
    enum :role, [:BUYER, :SELLER]
  
end
