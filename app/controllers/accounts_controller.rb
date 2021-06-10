class AccountsController < ApplicationController
  def show
    begin
      render json: Account.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {message: 'Account not found', status: 404}, status: :not_found
    end
  end

  def create
    params.required(:balance)

    acc = Account.new(:balance => params[:balance])
    if acc.save
      render json: Account.find(acc.id)
    else
      render json: {message: 'Invalid account', status: 404}, status: :not_found
    end

  end

  def list
    render json: Account.all
  end
end
