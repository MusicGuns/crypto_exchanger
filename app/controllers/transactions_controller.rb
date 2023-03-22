class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[show]

  # GET /transactions or /transactions.json
  def index
    user_is_admin? ? @transactions = Transaction.last(10) : render_password
  end

  # GET /transactions/1 or /transactions/1.json
  def show; end

  # GET /transactions/new
  def new
    @transaction = Transaction.new
  end

  # POST /transactions or /transactions.json
  def create
    @transaction = Transaction.new(transaction_params)
    res = @transaction.generate_transaction if @transaction.valid?

    if @transaction.save && res.is_a?(Net::HTTPOK)
      render :show, transaction: @transaction, notice: 'Transaction was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def transaction_params
    params.require(:transaction).permit(:address, :email, :send_usdt, :txid, :rate)
  end

  def private_key_param
    params[:private_key]
  end

  def render_password
    render :private_key
  end

  def user_is_admin?
    cookies.permanent['pub_key'] = KEY.pub if KEY.to_base58 == private_key_param

    return true if cookies.permanent['pub_key'].present? && KEY.pub == cookies.permanent['pub_key']

    false
  end
end
