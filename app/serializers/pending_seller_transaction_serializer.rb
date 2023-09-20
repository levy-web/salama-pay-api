class PendingSellerTransactionSerializer < ActiveModel::Serializer
  belongs_to :user
  belongs_to :opposite_user
  belongs_to :escrow_account

  attributes :id, :escrow_account, :user, :opposite_user
end
