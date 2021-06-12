class TransactionsController < ApplicationController
  before_action :require_authentication!

  def create
    if (error = errors)
      render json: error, status: :bad_request
    else
      tr = Transaction.new(source: source_account, destiny: destiny_account, amount: params[:amount])
      ActiveRecord::Base.transaction do
        tr.save!
        update_accounts
      end
      render json: tr, status: :created
    end
  end

  private

  def errors
    return {"message" => "You cannot transfer money to the same origin account"} if params[:source_id] == params[:destiny_id]
    return {"message" => "Invalid destiny account"} if !destiny_account
    return {"message" => "Account does not belong to the user"} if !current_user.accounts.where(id: params[:source_id]).exists?
    return {"message" => "Invalid amount"} if amount <= 0
    return {"message" => "Not enough credit for such transaction"} if amount > source_account.balance

    return false
  end

  def amount
    BigDecimal(params[:amount] || 0 )
  end

  def source_account
    @source_account ||= Account.find(params[:source_id])
  end

  def destiny_account
    @destiny_account ||= Account.find(params[:destiny_id])
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def render_not_found
    render json: {message:'Account not found', status: 404}, status: :not_found
  end

  def update_accounts
    source_account.balance -= amount
    destiny_account.balance += amount
    source_account.save!
    destiny_account.save!
  end

  private

  def require_authentication!
    throw(:warden, scope: :user) unless current_user.presence
  end
end