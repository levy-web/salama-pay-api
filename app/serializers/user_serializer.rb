class UserSerializer < ActiveModel::Serializer
  has_one :account
  has_many :sent_transactions
  has_many :received_transactions

  attributes :id, :firstName, :middleName, :surname
end
