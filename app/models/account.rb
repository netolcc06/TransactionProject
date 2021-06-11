class Account < ApplicationRecord
  validates :balance, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: {greater_than_or_equal_to: 0}
  has_many :transactions
  belongs_to :user
end
