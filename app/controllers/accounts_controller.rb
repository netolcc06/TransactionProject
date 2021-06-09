class AccountsController < ApplicationController
  def show
    begin
      render json: Account.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {message: 'Account not found', status: 404}, status: :not_found
    end
  end
end
