class InvoicesController < ApplicationController
  def new
    @invoice = Invoice.new
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
    params
      .require(:invoice)
      .permit(:invoice_number, :contract_number, :check_number, :invoice_type)
  end
end
