class Invoice < ApplicationRecord
  belongs_to :operation, optional: true
  belongs_to :payer, optional: true
  has_many :rebuys
  has_many :installments, dependent: :destroy
  # We need this line so that we can create invoice forms with installments (reference: https://www.youtube.com/watch?v=pulzZxPkgmE)
  accepts_nested_attributes_for :installments,
                                allow_destroy: true
                                # reject_if: :all_blank
  accepts_nested_attributes_for :payer,
                                allow_destroy: true
  # We need this to upload the invoices in xml format
  has_attached_file :xml_file

  # We need this so that the program understands that total_value is a Money object
  monetize :total_value_cents, with_model_currency: :currency


  def self.from_file(file)
    doc = Nokogiri::XML(file.read)
    file.rewind
    invoice = Invoice.new
    invoice = extract_invoice_general_info(doc, invoice)
    invoice = extract_payer_info(doc, invoice)


    # invoice.invoice_number = doc.search('fat nFat').text.strip
    # # delete("\n .")): takes out blanks spaces, points and paragraphs, otherwise Money class will read "1000.00" as 1000 and convert to 10.00
    # invoice.total_value = Money.new( doc.search('fat vLiq').text.delete("\n ."))

    #TODO: criar um método só para extrair os intallments
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

  private

  def self.extract_invoice_general_info (doc, invoice)
    invoice.invoice_number = doc.search('fat nFat').text.strip
    # delete("\n .")): takes out blanks spaces, points and paragraphs, otherwise Money class will read "1000.00" as 1000 and convert to 10.00
    invoice.total_value = Money.new(doc.search('fat vLiq').text.delete("\n ."))
    return invoice
  end

  def self.extract_payer_info (doc, invoice)
    payer = Payer.new
    doc.search('dest').each do |xml_payer_info|
      payer.identification_number =  xml_payer_info.search('CNPJ').text.strip
      payer.company_name =  xml_payer_info.search('xNome').text.strip
    end
    invoice.payer = payer
    return invoice
  end

end
