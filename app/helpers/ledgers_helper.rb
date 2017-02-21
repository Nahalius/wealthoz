module LedgersHelper
  def default_or_select_year
    if params[:date] && params[:date][:year]
      params[:date][:year].to_i
    else
      Date.today
    end
  end

end
