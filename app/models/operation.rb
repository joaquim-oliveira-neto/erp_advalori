class Operation < ApplicationRecord
  has_many :rebuys
  has_many :sellers_concentrations
  has_many :payers_concentrations
  has_many :sellers_limits
  has_many :payers_limits
  has_many :invoices
  belongs_to :seller
end
