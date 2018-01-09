class Invoice < ApplicationRecord
  belongs_to :operation
  belongs_to :payer
  has_many :rebuys
  has_many :installments
end
