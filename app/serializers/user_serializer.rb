class UserSerializer < ActiveModel::Serializer
  has_one :account
  has_many :sent_transactions
  has_many :received_transactions
  has_many :pending_seller_transactions
  has_many :pending_buyer_transactions

  attributes :id, :firstName, :middleName, :surname, :account, :held_fund
end
