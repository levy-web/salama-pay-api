class HeldFund < ApplicationRecord
  belongs_to :user

  def subtract_from_personal_held_balance(amount)
    self.amount -= amount
    save
  end

  def add_to_personal_held_balance(amount)
      self.amount += amount
      save
  end
end
