class TransparentsController < ApplicationController
  before_action :set_ledger, only: [:show, :edit, :update, :destroy]
  before_action :set_data, only: [:report, :report_balance, :report_plm, :report_plwu, :report_kpi, :report_story]


  def report_balance
  #  #Balance Sheet accounts
    @current_group = Group.find(2)

    @accounts_bs = @current_group.accounts.where(fs_id: [1,2,5])
    @accounts_bs_a = @current_group.accounts.where(fs_id: 1)
    @accounts_bs_d = @current_group.accounts.where(fs_id: 2)

    if params[:end_date]
      @ledgers = @current_group.ledgers.where('post_date <= ?', Date.parse(params[:end_date]))
    else
      @ledgers = @current_group.ledgers
    end
  #
    # @ledgers_bs = @ledgers.joins(:account).where(fs_id: [1,2,5])
    @ledgers_bs = @ledgers.joins(:account).where('fs_id = 1 OR fs_id = 2 OR fs_id = 5')
  #

    @ledgers_hash_bs = @ledgers_bs.group_by(&:wunit).sort_by {|k,v| k}.reverse.map do |k, v|
      [k, v.group_by(&:account_id)]
    end
  #
    @account_hash_bs = @ledgers_bs.group_by(&:account_id)
  #
  #
  #   #Draw Assets by WU
    @ledgers_bs_a = @ledgers.joins(:account).where('fs_id = 1')
    ledger_hash_a_summed = Hash[@ledgers_bs_a.group_by(&:wunit).map {|k, v| [k, v.reduce(0) {|sum, ledger| sum + ledger.ammount }]}]

  #
  #   #Draw Debt by WU !!! Problem if Wealth Unit has Debt but no Assets it wont appear on the graph
    @ledgers_bs_d = @ledgers.joins(:account).where('fs_id = 2')
    ledger_hash_d_summed = Hash[@ledgers_bs_d.group_by(&:wunit).map {|k, v| [k, v.reduce(0) {|sum, ledger| sum + ledger.ammount }]}]

    wunits = @current_group.users.pluck(:name) + @current_group.projects.pluck(:name)
    graph_assets =   wunits.map {|el| ledger_hash_a_summed.fetch(el, 0)}.as_json.map { |i| i.to_i }
    graph_debt =   wunits.map {|el| ledger_hash_d_summed.fetch(el, 0)}.as_json.map { |i| i.to_i }

    @chart_bs = LazyHighCharts::HighChart.new('column') do |f|
      f.chart(:width => 900 )
      f.series(:name=>'Assets',:data=> graph_assets )
      f.series(:name=>'Debt',:data=> graph_debt )
      f.title({ :text=>"Balance Sheet by Wealth Units " })
      f.xAxis(:categories => wunits )
      f.yAxis(:title => {:text => "All amounts in " + @fx})
      f.options[:chart][:defaultSeriesType] = "bar"
      f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
      f.plot_options(:bar=>{:stacking=>"normal",:dataLabels => {:enabled => "true",:color=>"grey"}})

    end
  end

  def report_plm
    if params[:date]
      @ledgers = @current_group.ledgers.where('extract(year  from post_date) = ?', params[:date][:year])
      # .where('post_date <= ?', Date.parse(params[:date][:year]))
    else
      @ledgers = @current_group.ledgers
    end


    @accounts_pl = @current_group.accounts.where('fs_id = 3 OR fs_id = 4')
    @ledgers_pl = @ledgers.joins(:account).where('fs_id = 3 OR fs_id = 4')
    @ledgers_hash_pl_m = @ledgers_pl.group_by{ |m| m.post_date.beginning_of_month}.sort_by {|k,v| k}.map do |k, v|
      [k, v.group_by(&:account_id)]
    end
    @account_hash_pl = @ledgers_pl.group_by(&:account_id)


    #chart
    #Draw Expenses by M
    @ledgers_expenses = @ledgers.joins(:account).where('fs_id = 4')
    @hash_expenses_m = @ledgers_expenses.group_by{ |item| item.post_date.beginning_of_month }
    # ledger_hash_a_summed = Hash[@ledgers_bs_a.group_by(&:wunit).map {|k, v| [k, v.reduce(0) {|sum, ledger| sum + ledger.ammount }]}]

    ledger_hash_expenses_summed = {}
    @ledgers_expenses.each do |item|
      key = item.post_date.beginning_of_month.month
      ledger_hash_expenses_summed[key] = 0 unless ledger_hash_expenses_summed[key]
      ledger_hash_expenses_summed[key] += item[:ammount]
    end

    #Draw Income by M
    @ledgers_income = @ledgers.joins(:account).where('fs_id = 3')
    @hash_income_m = @ledgers_income.group_by{ |item| item.post_date.beginning_of_month }
    ledger_hash_income_summed = {}
    @ledgers_income.each do |item|
      key = item.post_date.beginning_of_month.month
      ledger_hash_income_summed[key] = 0 unless ledger_hash_income_summed[key]
      ledger_hash_income_summed[key] += item[:ammount]
    end

    months = (1..12).to_a
    graph_income = months.map {|el| ledger_hash_income_summed.fetch(el, 0)}.as_json.map { |i| i.to_i }
    graph_expense = months.map {|el| ledger_hash_expenses_summed.fetch(el, 0)}.as_json.map { |i| i.to_i }
    graph_invest = graph_income.zip(graph_expense).map { |x, y| y + x }

    @chart_pl_m = LazyHighCharts::HighChart.new('column') do |f|
      f.chart(:width => 900)
      f.series(:type=> 'column',:name=>'Income',:data=> graph_income )
      f.series(:type=> 'column',:name=>'Expenses',:data=> graph_expense )
      f.series(:type=> 'spline',:name=> 'Investments(Borrowings)', :data=> graph_invest)
      f.title({ :text=>"Profit and Loss by Months"})
      f.xAxis(:categories => months, :title => {:text => "All amounts in " + @fx})
      f.options[:chart][:defaultSeriesType] = "column"
      f.legend(:align => 'top', :verticalAlign => 'left',:y=>20, :layout => 'horizontal',)
      f.plot_options(:column=>{:stacking=>"normal",})
    end

  end

  def report_plwu
    @accounts_pl = @current_group.accounts.where('fs_id = 3 OR fs_id = 4')
    if params[:start_date] && params[:end_date]
      @ledgers = @current_group.ledgers.where(post_date: Date.parse(params[:start_date]).beginning_of_day..Date.parse(params[:end_date]).end_of_day)
    else
      @ledgers = @current_group.ledgers
    end

    #Profit&Loss Transactions
    @ledgers_pl = @ledgers.joins(:account).where('fs_id = 3 OR fs_id = 4')

    #HAshes

    @ledgers_hash_pl = @ledgers_pl.group_by(&:wunit).sort_by {|k,v| k}.reverse.map do |k, v|
      [k, v.group_by(&:account_id)]
    end
   #Accounts
    @account_hash_pl = @ledgers_pl.group_by(&:account_id)


   #Charts
    #Draw Expenses by WU
    @ledgers_expenses = @ledgers.joins(:account).where('fs_id = 4')
    @hash_expenses_w = @ledgers_expenses.group_by{ |item| item[:wunit] }
    ledger_hash_expensesw_summed = {}
    @ledgers_expenses.each do |item|
    key = item[:wunit]
    ledger_hash_expensesw_summed[key] = 0 unless ledger_hash_expensesw_summed[key]
    ledger_hash_expensesw_summed[key] += item[:ammount]
    end

    #Draw Income by WU
    @ledgers_income = @ledgers.joins(:account).where('fs_id = 3')

    @hash_income_w = @ledgers_income.group_by{ |item| item[:wunit] }
    ledger_hash_incomew_summed = {}
    @ledgers_income.each do |item|
    key = item[:wunit]
    ledger_hash_incomew_summed[key] = 0 unless ledger_hash_incomew_summed[key]
    ledger_hash_incomew_summed[key] += item[:ammount]
    end

    wunits = @current_group.users.pluck(:name) + @current_group.projects.pluck(:name)
    graph_expensew = wunits.map {|el| ledger_hash_expensesw_summed.fetch(el, 0)}.as_json.map { |i| i.to_i }
    graph_incomew = wunits.map {|el| ledger_hash_incomew_summed.fetch(el, 0)}.as_json.map { |i| i.to_i }


   @chart_pl_w = LazyHighCharts::HighChart.new('column') do |f|
      f.chart(:width => 900)
      f.series(:name=>'Income',:data=> graph_incomew)
      f.series(:name=>'Expenses',:data=> graph_expensew  )
      f.title({ :text=>"Profit and Loss by Wealth Units"})
      f.xAxis(:categories => wunits)
      f.yAxis(:title => {:text => "All amounts in " + @fx})
      f.options[:chart][:defaultSeriesType] = "bar"
      f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
      f.plot_options(:bar=>{:stacking=>"normal",:dataLabels => {:enabled => "true",:color=>"black",}})
    end
  end


  def report_kpi
    @ledgers = @current_group.ledgers

    @accounts_bs = @current_group.accounts.where('fs_id = 1 OR fs_id = 2 OR fs_id = 5')
    @accounts_bs_a = @current_group.accounts.where('fs_id = 1')
    @accounts_bs_d = @current_group.accounts.where('fs_id = 2')


    @ledgers_pl = @ledgers.joins(:account).where('fs_id = 3 OR fs_id = 4')

   #Profit and loss accounts
    @accounts_pl = @current_group.accounts.where('fs_id = 3 OR fs_id = 4')
    @account_hash_pl = @ledgers_pl.group_by(&:account_id)


    @ledgers = @current_group.ledgers
   #Balance Sheet Transactions
    @ledgers_bs = @ledgers.joins(:account).where('fs_id = 1 OR fs_id = 2 OR fs_id = 5')
   #Profit&Loss Transactions
    @ledgers_pl = @ledgers.joins(:account).where('fs_id = 3 OR fs_id = 4')

   #HAshes
    @ledgers_hash_bs = @ledgers_bs.group_by(&:wunit).sort_by {|k,v| k}.reverse.map do |k, v|
      [k, v.group_by(&:account_id)]
    end

    @ledgers_hash_pl = @ledgers_pl.group_by(&:wunit).sort_by {|k,v| k}.reverse.map do |k, v|
      [k, v.group_by(&:account_id)]
    end

    @hash_group_index = @ledgers_bs.group_by{ |item| item.post_date }
    ledger_hash_index_summed = {}
    @ledgers_bs.each do |item|
      key = item.post_date.beginning_of_week
      ledger_hash_index_summed[key] = 0 unless ledger_hash_index_summed[key]
      ledger_hash_index_summed[key] += item[:ammount]
    end

    @ledgers_bs_a = @ledgers.joins(:account).where('fs_id = 1')
    @ledgers_hash_bs_a = @ledgers_bs_a.group_by{ |item| item[:wunit] }
    ledger_hash_a_summed = {}
    @ledgers_bs_a.each do |item|
    key = item[:wunit]
    ledger_hash_a_summed[key] = 0 unless ledger_hash_a_summed[key]
    ledger_hash_a_summed[key] += item[:ammount]
    end

    @account_hash_bs = @ledgers_bs.group_by(&:account_id)

    @ledgers_income = @ledgers.joins(:account).where('fs_id = 3')
    @hash_income_m = @ledgers_income.group_by{ |item| item.post_date.beginning_of_month }
    ledger_hash_income_summed = {}
    @ledgers_income.each do |item|
    key = item.post_date.beginning_of_month.month
    ledger_hash_income_summed[key] = 0 unless ledger_hash_income_summed[key]
    ledger_hash_income_summed[key] += item[:ammount]
    end

    #Graph Index = ledger_hash_index values - accumulated
    #Sorts the index hash by weeks and displays accum wealth
    graph_index =  ledger_hash_index_summed.sort.to_h.values.as_json.map{ |i| i.to_i }.inject([]) { |x, y| x + [(x.last || 0) + y] }
    graph_weeks = ledger_hash_index_summed.sort.to_h.keys

    #Draw KPI's
    months = (1..12).to_a

    wunits = @current_group.users.pluck(:name) + @current_group.projects.pluck(:name)
    graph_assets =   wunits.map {|el| ledger_hash_a_summed.fetch(el, 0)}.as_json.map { |i| i.to_i }
    graph_income = months.map {|el| ledger_hash_income_summed.fetch(el, 0)}.as_json.map { |i| i.to_i }

    @wealth_assets = @account_hash_bs.values.flatten.map(&:ammount).inject(0, &:+)/(graph_assets.inject(:+) + 0.00001) *100  #No zeros
    @margin =  @account_hash_pl.values.flatten.map(&:ammount).inject(0, &:+)/(graph_income.inject(:+) + 0.00001) *100   #No zeros

   @chart_index = LazyHighCharts::HighChart.new('line') do |f|
      f.chart(:width => 900,:height => 500)
      f.series(:type=> 'area',:name=>'Wealth Index',:data=> graph_index )
      f.title({ :text=> @current_group.name + " Wealth : amounts in " + @fx})
      f.xAxis(:title => {:text => "All amounts in " + @fx})
      f.yAxis(:min => 140000 )
      f.options[:chart][:defaultSeriesType] = "line"
      f.legend(:align => 'top', :verticalAlign => 'left',:y=>40,:x=>30, :layout => 'horizontal',)
    end

    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string'  , 'Label')
    data_table.new_column('number'  , 'Value')
    data_table.add_rows(2)
    data_table.set_cell(0, 0, 'W/A %' )
    data_table.set_cell(0, 1, @wealth_assets.round)
    data_table.set_cell(1, 0, 'Margin %')
    data_table.set_cell(1, 1, @margin.round)

    opts   = { :width => 550, :height => 550, :greenFrom => 50, :greenTo => 30,
      :yellowFrom => 10, :yellowTo => 0,:redFrom =>0,:redTo =>-30 ,:minorTicks => 5,:min => 50, :max => -30 }
    @chart_ratio = GoogleVisualr::Interactive::Gauge.new(data_table, opts)
    render


  end

  def report_story
end

alias_method :report, :report_balance




  private
    # Use callbacks to share common setup or constraints between actions.

    # Never trust parameters from the scary internet, only allow the white list through.

    def set_data
      @current_group = Group.find(2)
      @fx = @current_group.fx.fx
    end

    def ledger_params
      params.permit(ledgers: [:account_id, :group_id, :post_date, :ammount, :text, :wunit])
    end

    def single_ledger_params
      params.require(:ledger).permit([:account_id, :group_id, :post_date, :ammount, :text, :wunit])
    end

    def set_ledger
      @ledger = Ledger.find(params[:id])
    end
end
