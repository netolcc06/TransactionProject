class TransactionsController < ApplicationController
  before_action :require_authentication!

  def create
    if current_user.accounts.where(id: params[:source_id]).exists?
      tr = Transaction.new(source: source_account, destiny: destiny_account, amount: params[:amount])
      ActiveRecord::Base.transaction do
        tr.save!
        update_accounts
      end
      render json: tr, status: :created
    else
      render json: {"error" => "Account does not belong to the user",
                    "user_id" => current_user.id}, status: :forbidden
    end
  end

  def source_account
    @source_account ||= Account.find(params[:source_id])
  end

  def destiny_account
    @destiny_account ||= Account.find(params[:destiny_id])
  end

  def render_not_found
    render json: {message:'Account not found', status: 404}, status: :not_found
  end

  def update_accounts
    if BigDecimal(params[:amount]) > source_account.balance
      raise Exception.new "Not enough credit for such transaction"
    end
    source_account.balance -= params[:amount]
    destiny_account.balance += params[:amount]
    source_account.save!
    destiny_account.save!
  end

  private

  def require_authentication!
    throw(:warden, scope: :user) unless current_user.presence
  end
end