class InvoicesController < ApplicationController
  def new
    @invoice = Invoice.new
    @invoice.installments.build
  end
  def create
    @invoice = Invoice.new(invoice_params)
    # @seller.client = current_user.client
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
      .permit(:invoice_number, :contract_number, :check_number, :invoice_type, installments_attributes: [:id, :invoice_id, :_destroy, :number, :value_cents, :due_date])
  end
end
