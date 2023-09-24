class PendingSellerTransactionSerializer < ActiveModel::Serializer
  belongs_to :user
  belongs_to :opposite_user
  belongs_to :escrow_account

  attributes :id, :buyer_confirmation, :amount, :user, :opposite_user
end
