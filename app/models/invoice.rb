class Invoice < ApplicationRecord
  belongs_to :operation, optional: true
  belongs_to :payer, optional: true
  has_many :rebuys
  has_many :installments

  def seller
    operation.seller
  end
end
