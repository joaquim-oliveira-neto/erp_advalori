class Invoice < ApplicationRecord
  belongs_to :operation, optional: true
  belongs_to :payer, optional: true
  has_many :rebuys
  has_many :installments, dependent: :destroy
  # We need this line so that we can create invoice forms with installments (reference: https://www.youtube.com/watch?v=pulzZxPkgmE)
  accepts_nested_attributes_for :installments,
                                allow_destroy: true
                                # reject_if: :all_blank
  has_attached_file :xml_file

  def self.from_file(file)
    doc = Nokogiri::XML(file.read)
    file.rewind
    invoice = Invoice.new
    invoice.invoice_number = doc.search('fat nFat').text.strip
    invoice.total_value_cents = doc.search('fat vLiq').text.to_f
    # invoice.save!
    return invoice
  end

  # def seller
  #   operation.seller
  # end

end
