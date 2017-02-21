class CutOffWealthsController < ApplicationController

  def new
    current_group = current_user.group
    authorize(current_group)

    @accounts = current_group.accounts.where(fs: [1,2]).group_by(&:fs).map do |k,v|
      [k.report_class, v.map {|el|  [el.name, el.id] }]
    end

    @wunit = {
               Projects: current_group.projects.pluck(:name),
               People: current_group.users.pluck(:name)
             }
    @cut_off_wealth = Ledger.new
  end


  def create
    current_group = current_user.group

    current_group.ledgers.create(cut_off_wealths_params[:cut_off_wealths])

    respond_to do |format|
      # if @ledger.save
        format.html { redirect_to ledgers_path, notice: 'You successfully cut-off your Wealth.' }
        format.json { render action: 'index', status: :created, location: @ledger }
        format.js { render js: 'alert("You successfully cut-off your Wealth.")'}
      # else
      #   format.html { render action: 'new' }
      #   format.json { render json: @ledger.errors, status: :unprocessable_entity }
      # end
    end
  end

  private

  def cut_off_wealths_params
    params.permit(cut_off_wealths: [:account_id, :group_id, :post_date, :ammount, :text, :wunit])
  end

end
