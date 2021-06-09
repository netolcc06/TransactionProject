class TransactionsController < ApplicationController
  def create
    params.require(:source_id)
    params.require(:destiny_id)
    params.require(:amount)

    render json: 'Source account not found', status: :not_found if Account.exists?(params[:source_id])
    render json: 'Destiny account not found', status: :not_found if Account.exists?(params[:destiny_id])

    Transaction.new(params.permit(:source_id, :destiny_id, :amount))
  end
end
