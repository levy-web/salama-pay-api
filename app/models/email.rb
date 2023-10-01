class Email < ApplicationRecord
  validates :transaction_id, presence: true
  validates :issue_details, presence: true
  validates :dispute_details, presence: true
end
