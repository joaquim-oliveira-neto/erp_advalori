class Invoice < ApplicationRecord
  belongs_to :operation, optional: true
  belongs_to :payer, optional: true
  has_many :rebuys
  has_many :installments, dependent: :destroy
  # We need this line so that we can create invoice forms with installments (reference: https://www.youtube.com/watch?v=pulzZxPkgmE)
  accepts_nested_attributes_for :installments,
                                allow_destroy: true
                                # reject_if: :all_blank
  # We need this to upload the invoices in xml format
  has_attached_file :xml_file

  # We need this so that the program understands that total_value is a Money object
  monetize :total_value_cents, with_model_currency: :currency


  def self.from_file(file)
    doc = Nokogiri::XML(file.read)
    file.rewind
    invoice = Invoice.new
    invoice.invoice_number = doc.search('fat nFat').text.strip
    # delete("\n .")): takes out blanks spaces, points and paragraphs, otherwise Money class will read "1000.00" as 1000 and convert to 10.00
    invoice.total_value = Money.new( doc.search('fat vLiq').text.delete("\n ."))

    dups = doc.search('dup')
    dups.each do |dup|
      i = Installment.new
      i.number = dup.search('nDup').text.strip
      # delete("\n .")): takes out blanks spaces, points and paragraphs, otherwise Money class will read "1000.00" as 1000 and convert to 10.00
      i.value = Money.new(dup.search('vDup').text.delete("\n ."))
      i.due_date = dup.search('dVenc').text.strip
      i.invoice = invoice
      invoice.installments.push(i)
    end
    return invoice
  end

end
