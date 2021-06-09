class Transaction < ApplicationRecord
  before_save :update_accounts
  validates :amount, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: {greater_than_or_equal_to: 0}
  validates :source_id, presence: true
  validates :destiny_id, presence: true
  belongs_to :source, class_name: "Account", foreign_key: "source_id"
  belongs_to :destiny, class_name: "Account", foreign_key: "destiny_id"

  def update_accounts
    if amount > source.balance
      raise Exception.new "Not enough credit for such transaction"
    end
    source.balance -= amount
    destiny.balance += amount
    source.save
    destiny.save
  end
end
