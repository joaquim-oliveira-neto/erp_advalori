class InvoicesController < ApplicationController
  def new
    @invoice = Invoice.new
    @invoice.installments.build
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

  def create
    @invoice = Invoice.new(invoice_params)
    @invoice.save
    if @invoice.save
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def invoice_params
    # In the strong parameters we need to pass the attributes of intallments so that the invoice form can undertant it
    params
      .require(:invoice)
      .permit(:invoice_number, :total_value, :contract_number, :check_number, :invoice_type, installments_attributes: [:id, :invoice_id, :_destroy, :number, :value, :due_date])
  end
end
