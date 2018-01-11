class Invoice < ApplicationRecord
  belongs_to :operation, optional: true
  belongs_to :payer, optional: true
  has_many :rebuys
  has_many :installments, dependent: :destroy
  # We need this line so that we can create invoice forms with installments (reference: https://www.youtube.com/watch?v=pulzZxPkgmE)
  accepts_nested_attributes_for :installments,
                                allow_destroy: true
                                # reject_if: :all_blank

  # def seller
  #   operation.seller
  # end
end
