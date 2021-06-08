class AccountsController < ApplicationController
  def show
    begin
      render json: Account.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: 'Account not found', status: :not_found
    end
  end
end
