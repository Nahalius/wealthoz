class FutureReportsController < ApplicationController

  # def index
  #
  # end
  def future_balance
    @current_group = current_user.group
    authorize(@current_group, :view?)
    @fx = @current_group.fx.fx
    
    @accounts_bs = @current_group.accounts.where(fs_id: [1,2])

    if params[:end_date]
      ledgers = @current_group.ledgers.where('post_date < ?', Date.parse(params[:end_date]))
      budgets = @current_group.budgets.where('budget_date < ?', Date.parse(params[:end_date])).where('budget_date > ?', ledgers.last.post_date)
    else
      ledgers = @current_group.ledgers
      budgets = @current_group.budgets.where('budget_date > ?', ledgers.last.post_date)
    end

    ledgers_bs = ledgers.joins(:account).where('fs_id = 1 OR fs_id = 2')
    budgets_bs = budgets.joins(:account).where('fs_id = 1 OR fs_id = 2')

    @all_transactions = ledgers_bs + budgets_bs

    @all_transactions_hash_bs = @all_transactions.group_by(&:wunit).sort_by {|k,v| k}.reverse.map do |k, v|
      [k, v.group_by(&:account_id)]
    end

    chart_transactions =  Hash[@all_transactions_hash_bs]

    @account_hash_bs = @all_transactions.group_by(&:account_id)

    testo = Hash[@account_hash_bs.map {|k, v| [k, v.group_by(&:wunit)]}]

    @chart_future_balance = LazyHighCharts::HighChart.new('column') do |f|
      f.chart(:width => 800)
      @accounts_bs.each do |account|
          data = chart_transactions.keys.map  do |wunit|
          if testo[account.id] && testo[account.id][wunit]
            testo[account.id][wunit].inject(0) { |sum, obj| sum + obj.ammount }.to_i
          else
            0
          end

        end

        f.series(name: "#{account.name}",:data => data)
      end
       f.title({ :text=>"Future Balance by Wealth Units"})
       f.xAxis(:categories => chart_transactions.keys)
      #  f.yAxis(:title => {:text => "All amounts in " + @fx})
       f.options[:chart][:defaultSeriesType] = "column"
       f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
       f.plot_options(:column=>{:stacking => 'bar'})
     end

  end
  alias_method  :index, :future_balance

  def actual_budget
    @current_group = current_user.group
    @fx = @current_group.fx.fx
    @accounts_pl = @current_group.accounts.where(fs_id: [3,4])

    if params[:start_date] && params[:end_date]
      # raise "#{Date.parse(params[:start_date]).beginning_of_day} | #{Date.parse(params[:end_date]).beginning_of_day}".inspect
      ledgers = @current_group.ledgers.where(post_date: Date.parse(params[:start_date]).beginning_of_day..Date.parse(params[:end_date]).end_of_day)
      budgets = @current_group.budgets.where(budget_date: Date.parse(params[:start_date]).beginning_of_day..Date.parse(params[:end_date]).end_of_day)
    else
      ledgers = @current_group.ledgers
      budgets = @current_group.budgets
    end

    @ledgers_pl = ledgers.joins(:account).where(accounts: { fs_id: [3,4] })
    @budgets_pl = budgets.joins(:account).where(accounts: { fs_id: [3,4] })

    @ledgers_hash_pl = @ledgers_pl.group_by(&:account_id)
    @budgets_hash_pl = @budgets_pl.group_by(&:account_id)

    @total = {}
    @accounts_pl.each do |account|
      actual = @ledgers_hash_pl[account.id].inject(0) { |sum, obj| sum + obj.ammount } if @ledgers_hash_pl[account.id]
      budget = @budgets_hash_pl[account.id].inject(0) { |sum, obj| sum + obj.ammount } if @budgets_hash_pl[account.id]
      @total[account.id] = actual.to_i - budget.to_i if budget || actual
    end

    account_chart = @accounts_pl.map(&:name)

    actual_chart, budget_chart = [], []
    @accounts_pl.each do |account|
      group = @ledgers_hash_pl.fetch(account.id, 0)
      if group.kind_of?(Array)
        actual_chart << group.inject(0) { |sum, obj| sum + obj.ammount }
      else
        actual_chart << group
      end
    end

    @accounts_pl.each do |account|
      group = @budgets_hash_pl.fetch(account.id, 0)
      if group.kind_of?(Array)
        budget_chart << group.inject(0) { |sum, obj| sum + obj.ammount }
      else
        budget_chart << group
      end
    end


    @chart_actual_budget = LazyHighCharts::HighChart.new('column') do |f|
       f.chart(:width => 800)
       f.series(:name=>'Actual',:data=> actual_chart.map(&:to_i))
       f.series(:name=>'Budget',:data=> budget_chart.map(&:to_i))
       f.title({ :text=>"Actual vs Budget (Income and Expenses)"})
       f.xAxis(:categories => account_chart)
      #  f.yAxis(:title => {:text => "All amounts in " + @fx})
       f.options[:chart][:defaultSeriesType] = "bar"
       f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
       f.plot_options(:bar=>{:dataLabels => {:enabled => "true",:color=>"black",}})
     end



  end


end
