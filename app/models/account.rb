class Account < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :currency_id, scope: [:user_id]
end
