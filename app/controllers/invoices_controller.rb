class InvoicesController < ApplicationController
  def new
    @invoice = Invoice.new
    @invoice.installments.build
    @invoice.build_payer
    @invoice.build_operation
  end

  def load_invoice_from_xml
    if params[:invoice][:xml_file].present?
      @invoice = Invoice.from_file(params[:invoice][:xml_file])
      render :new
      return
    else
      redirect_to new_invoice_path
    end
  end

  # TODO: refactor with the Invoice class method self.extract_payer_info
  def create
    invoice = Invoice.new(invoice_and_intallments_params)
    invoice.operation = Operation.new(operation_params[:operation_attributes])
    payer_identification_number = payer_params[:payer_attributes][:identification_number]
    if Payer.exists?(identification_number: payer_identification_number)
      payer = Payer.find_by_identification_number(payer_identification_number)
    else
      payer = Payer.new(payer_params[:payer_attributes])
      payer.save!
    end
    seller_identification_number = seller_params[:operation_attributes][:seller_attributes][:identification_number]
    if Seller.exists?(identification_number: seller_identification_number)
      seller = Seller.find_by_identification_number(seller_identification_number)
    else
      seller = Seller.new(seller_params[:operation_attributes][:seller_attributes])
      seller.client = current_user.client
      seller.save!
    end
    invoice.payer = payer
    invoice.operation.seller = seller
    average = 0
    invoice.installments.each do |i|
      # TODO mexi nesta linha preciso deixar como estava antes
      i.outstanding_days = 30 # TODO: Datetime.now will change to creation Operation date
      average += i.outstanding_days
    end
    invoice.save!
    if invoice.save!
      invoice.average_outstanding_days = (average / invoice.installments.count) # TODO: Refactor to bring these lines above
      invoice.save!
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def invoice_and_intallments_params
    # In the strong parameters we need to pass the attributes of intallments so that the invoice form can understand it
    params
      .require(:invoice)
      .permit(:invoice_number, :total_value, :contract_number, :check_number, :invoice_type, installments_attributes: [:id, :invoice_id, :_destroy, :number, :value, :due_date])
  end

  def operation_params
    params
      .require(:invoice)
      .permit(operation_attributes: [:status])
  end

  def payer_params
    params
      .require(:invoice)
      .permit(payer_attributes: [:company_name, :identification_number, :address, :address_number, :neighborhood, :city, :state, :zip_code, :registration_number])
  end

  def seller_params
    params
      .require(:invoice)
      .permit(operation_attributes: [seller_attributes: [:company_name]])
  end
end
