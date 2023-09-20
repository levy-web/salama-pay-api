class PendingSellerTransaction < ApplicationRecord
    belongs_to :user
    belongs_to :opposite_user, class_name: 'User'
    belongs_to :escrow_account, class_name: 'EscrowAccount', foreign_key: 'escrow_account_id'
  
    enum :status, [:PENDING, :COMPLETED, :CANCELED]
    enum buyer_confirmation: [:NOT_CONFIRMED, :CONFIRMED, :REJECT]
end
