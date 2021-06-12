class AccountsController < ApplicationController
  before_action :require_authentication!

  def show
    begin
      render json: Account.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: {message: 'Account not found', status: 404}, status: :not_found
    end
  end

  def create
    params.required(:balance)

    acc = Account.new(:balance => params[:balance], user: current_user)
    if acc.save
      render json: Account.find(acc.id)
    else
      render json: {message: 'Invalid account', status: 404}, status: :not_found
    end
  end

  def list
    accounts = current_user.accounts
    render json: accounts
  end

  private

  def require_authentication!
    throw(:warden, scope: :user) unless current_user.presence
  end
end
