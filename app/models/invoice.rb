class Invoice < ApplicationRecord
  belongs_to :operation, optional: true
  belongs_to :payer, optional: true
  has_many :rebuys
  has_many :installments

  has_attached_file :xml_file

  def self.from_file(file)

    doc = Nokogiri::XML(file.read)
    file.rewind

    invoice = Invoice.new
    invoice.invoice_number = doc.search('fat nFat').text.strip
    invoice.total_value_cents = doc.search('fat vLiq').text.to_f
    invoice.save!

    return invoice
  end
end
