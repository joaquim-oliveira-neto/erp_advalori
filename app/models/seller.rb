class Seller < ApplicationRecord
  belongs_to :client
  has_many :equity_holders
  has_many :sellers_limits
  has_many :sellers_concentrations
  has_many :operations
  has_many :invoices, through: :operations
  accepts_nested_attributes_for :operations
  accepts_nested_attributes_for :invoices
end
