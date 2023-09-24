class TransactionSerializer < ActiveModel::Serializer
  belongs_to :user
  belongs_to :opposite_user
  belongs_to :escrow_account

  attributes :id, :role, :status, :amount, :user, :opposite_user
end
