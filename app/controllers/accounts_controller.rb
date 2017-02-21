class AccountsController < ApplicationController

  respond_to :json, :html

  before_action :set_account, only: [:show, :update,]

  # GET /accounts
  # GET /accounts.json

  def index
    current_group = current_user.group
    authorize(current_group)

    @accounts = current_group.accounts.joins(:fs)

    respond_to do |format|
      format.html
      format.csv { send_data @accounts.to_csv }
      format.xls # { send_data @accounts.to_csv(col_sep: "\t") }
    end
  end

  # GET /accounts/1
  # GET /accounts/1.json

  def show
    current_group = current_user.group
    authorize(current_group)
    @account = Account.find(params[:id])
  end

  # GET /accounts/new
  def new
    current_group = current_user.group
    authorize(current_group)
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
    current_group = current_user.group
    authorize(current_group)
    @account = Account.find(params[:id])
    @accounts = current_group.accounts

  end

  # POST /accounts
  # POST /accounts.json
  def create
    current_group = current_user.group
    authorize(current_group)

    @account = current_group.accounts.build(account_params)

    respond_to do |format|
      if @account.save
        format.html { redirect_to accounts_path, notice: 'Account was successfully created.' }
        format.json { render action: 'index', status: :created, location: @account }
      else
        format.html { render action: 'new' }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def check
    # @account = Account.find(params[:id])
    # @fs = @account.fs
    # @fs_account_ids = Account.where(fs_id: @fs.id).pluck(:id)
    @grouped_accounts = Hash[Account.all.group_by(&:fs_id).map {|k, v| [k, v.map(&:id)]}]
    @fss = Hash[Fs.all.map {|ob| [ob.id, ob.report_class ]}]

    render json: { grouped_accounts: @grouped_accounts, fss: @fss }.as_json
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    current_group = current_user.group
    authorize(current_group)
    @account = Account.find(params[:id])
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  #def destroy
    #@account = Account.find(params[:id])

    #@account.destroy
    #redirect_to accounts_path
  #end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:name, :user_id, :fs_id)
    end
end
