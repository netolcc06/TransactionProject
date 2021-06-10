class TransactionsController < ApplicationController
  def create
    create_params
    return render_not_found unless Account.exists?(params[:source_id])
    return render_not_found unless Account.exists?(params[:destiny_id])

    tr = Transaction.new(:source_id => params[:source_id], :destiny_id => params[:destiny_id], :amount => params[:amount])
    if tr.save
      render json: Transaction.find(tr.id)
    end

  end

  def create_params
    params.require(:source_id)
    params.require(:destiny_id)
    params.require(:amount)
  end

  def render_not_found
    render json: {message:'Account not found', status: 404}, status: :not_found
  end
end