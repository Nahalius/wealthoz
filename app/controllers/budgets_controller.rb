class BudgetsController < ApplicationController
  #before_action :set_budget, only: [:show, :edit, :update, :destroy]


  def index

    current_group = current_user.group
    authorize(current_group)

    @budgets = current_group.budgets
    @ledgers = current_group.ledgers
    @entries = @budgets + @ledgers
    @accounts_bs = current_group.accounts.where('fs_id = 1 OR fs_id = 2 OR fs_id = 5')



  end

  def show
    @budget = Budget.find(params[:id])
  end

  def new
    current_group = current_user.group
    authorize(current_group)
    @accounts = current_group.accounts.group_by(&:fs).map do |k,v|
      [k.report_class, v.map {|el|  [el.name, el.id] }]
    end


   @wunit = {
              Projects: current_group.projects.pluck(:name),
              People: current_group.users.pluck(:name)
            }
   @budget = Budget.new
  end


  def edit
    current_group = current_user.group
    @accounts = current_group.accounts
    @users =  current_group.users
    @projects = current_group.projects

    @wunits = @users + @projects
    @budget = Budget.find(params[:id])
  end

  def create
    current_group = current_user.group

    current_group.budgets.create(budget_params[:budgets])

    respond_to do |format|
      format.html { redirect_to :back, notice: 'Budget was successfully created.' }
      format.json { render action: 'index', status: :created, location: @budget }
      format.js
    end

   end


  def update

    @budget = Budget.find(params[:id])
    respond_to do |format|
      if @budget.update(single_budget_params)
        format.html { redirect_to budgets_url, notice: 'Budget was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'index' }
        format.json { render json: @budget.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /budgets/1
  # DELETE /budgets/1.json
  def destroy
    @budget = Budget.find(params[:id])
    @budget.destroy
    respond_to do |format|
      format.html { redirect_to budgets_url }
      format.json { head :no_content }
    end
  end

  private

    def budget_params
      params.permit(budgets: [:account_id, :group_id, :budget_date, :ammount, :text, :wunit])
    end

    def single_budget_params
      params.require(:budget).permit([:account_id, :group_id, :budget_date, :ammount, :text, :wunit])
    end

    def set_budget
      @budget = Budget.find(params[:id])
    end

end
