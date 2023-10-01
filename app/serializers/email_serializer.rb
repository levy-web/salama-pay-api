class EmailSerializer < ActiveModel::Serializer
  attributes :id, :transaction_id, :issue_details, :dispute_details
end
