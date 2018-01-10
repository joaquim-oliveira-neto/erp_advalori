class Invoice < ApplicationRecord
  belongs_to :operation
  belongs_to :payer
  belongs_to :seller
  has_many :rebuys
  has_many :installments
  accepts_nested_attributes_for :operation
  accepts_nested_attributes_for :seller
end
