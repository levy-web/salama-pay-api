class UserSerializer < ActiveModel::Serializer
  has_one :account
  has_many :sent_transactions
  has_many :received_transactions
  has_many :pending_seller_transactions
  has_many :pending_buyer_transactions

  attributes :id, :firstName, :middleName, :surname, :account, :held_fund, :verified, :id_front_url, :id_back_url, :profile_pic_url
end
