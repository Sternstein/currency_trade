class Account < ApplicationRecord
  belongs_to :user
  validates_numericality_of :amount, :greater_than_or_equal_to =>0
  validates_uniqueness_of :currency_id, scope: [:user_id]

  def currency_name
    Currency.find_by(id: self.currency_id).name
  end

end
