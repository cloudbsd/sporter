class TransactionsController < ApplicationController
  before_action :set_group
  before_action :set_transaction, only: [:show, :edit, :update, :destroy]

  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = @group.transactions
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @transaction = Transaction.new(amount: 0, operated_at: Date.today)
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions
  # POST /transactions.json
  def create
    if params[:transaction][:card_id].nil?
      user = User.find_by id: params[:transaction][:user_id]
      debit = user.find_or_create_debit_card! @group.id
      params[:transaction][:card_id] = debit.id
    end

    @transaction = Transaction.new(transaction_params)

    respond_to do |format|
      if @transaction.save
      # @transaction.card.calculate_balance if @transaction.card.is_debit_card?
        format.html { redirect_to [@group, @transaction], notice: 'Transaction was successfully created.' }
        format.json { render action: 'show', status: :created, location: @transaction }
      else
        format.html { render action: 'new' }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transactions/1
  # PATCH/PUT /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
      # @transaction.card.calculate_balance if @transaction.card.is_debit_card?
        format.html { redirect_to [@group, @transaction], notice: 'Transaction was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction.destroy
  # @transaction.card.calculate_balance if @transaction.card.is_debit_card?
    respond_to do |format|
      format.html { redirect_to group_transactions_url(@group) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:group_id])
    end

    def set_transaction
      @transaction = Transaction.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def transaction_params
      params.require(:transaction).permit(:user_id, :card_id, :action, :amount, :operated_at)
    end
end
