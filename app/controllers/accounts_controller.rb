class AccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account, only: %i[ show edit update destroy recharge recharge_it]
  # GET /accounts or /accounts.json
  def index
    @accounts = current_user.accounts.all
  end

  # GET /accounts/1 or /accounts/1.json
  def show
  end

  # GET /accounts/new
  def new
    @account = Account.new 
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts or /accounts.json
  def create
    @account = Account.new(account_params)
    @account.user = current_user
    respond_to do |format|
      if @account.save
        format.html { redirect_to @account, notice: "Account was successfully created." }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def recharge
  end 

  def recharge_it
    new_amount = BigDecimal(params['recharge'])
    if new_amount > BigDecimal(0)
      current_amount = @account.amount
      @account.amount = current_amount + new_amount
      if @account.save
        redirect_to accounts_path
      else
        flash[:alert] = "Unexpected error!"
        render :recharge, status: :unprocessable_entity
      end
    else
      flash[:alert] = "Amount of recharge should be more than zero!"
      render :recharge, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounts/1 or /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: "Account was successfully updated." }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1 or /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: "Account was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_params
      params.require(:account).permit(:currency_id, :amount, :recharge)
    end
end
