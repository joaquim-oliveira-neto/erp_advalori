class Installment < ApplicationRecord
  belongs_to :invoice, optional: true
end
