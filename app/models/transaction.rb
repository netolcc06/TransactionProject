class Transaction < ApplicationRecord
  validates :amount, presence: true, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }, numericality: {greater_than: 0}
  validates :source_id, :destiny_id, presence: true
  belongs_to :source, class_name: "Account", foreign_key: "source_id"
  belongs_to :destiny, class_name: "Account", foreign_key: "destiny_id"
end
