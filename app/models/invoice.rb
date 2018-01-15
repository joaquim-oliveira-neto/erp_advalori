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
    invoice.total_value = Money.new(doc.search('fat vLiq').text.to_f)

    dups = doc.search('dup')
    dups.each do |dup|
      i = Installment.new
      i.number = dup.search('nDup').text.strip
      i.value = Money.new(dup.search('vDup').text.to_f)
      i.due_date = dup.search('dVenc').text.strip
      i.invoice = invoice
      invoice.installments.push(i)
      # i.save!
      # i.outstanding_days = TimeDifference.between(i.due_date, i.updated_at).in_days
      # i.save
    end
    return invoice
  end

end
