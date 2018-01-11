class InvoicesController < ApplicationController
  def new
    @invoice = Invoice.new
  end

  def create
    if params[:invoice][:xml_file].present?
      @invoice = Invoice.from_file(params[:invoice][:xml_file])

      if @invoice.nil?
        redirect_to new_invoice_path
        return
      end

    else
      @invoice = Invoice.new(invoice_params)
      @invoice.payer = payer
      @invoice.seller = current_user.client.seller
      @invoice.save!
    end

    redirect_to root_path
  end

  private

  def invoices_params
    params.require(:invoice).permit(:number, :total_value)
  end
end
