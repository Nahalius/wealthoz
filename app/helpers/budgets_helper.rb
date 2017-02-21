module BudgetsHelper
  def wealth_assets_text(wealth_asset)
    if wealth_asset > 30
      alert_info 'W/A% - Wealth to Assets - You are having strong foundations to build your Wealth. 
      Your Debt is probably at a reasonable level. Keep up the good work. 
      This ratio compares your group accumulated Wealth to your Assets. 

      '
    elsif wealth_asset < 30 && wealth_asset > 10
      alert_info 'W/A% - Wealth to Assets - You are not in the danger zone yet. 
      You should focus on acquiring more Assets with less Debt.
      This ratio compares your group accumulated Wealth to your Assets.
      '
    elsif wealth_asset < 10 && wealth_asset > 0
      alert_info 'W/A% - Wealth to Assets - You are walking on a thin ice. 
      You either have few investments in Assets or you have too much Debt. 
      Lower your Debt or invest part of your money in new Assets.
      This ratio compares your group accumulated Wealth to your Assets. 
      '
    elsif wealth_asset < 0
      alert_info 'W/A% - Wealth to Assets - It looks like you are not managing your finance wisely. 
      Find ways to lower your Debt, save money and invest in Assets.
      This ratio compares your group accumulated Wealth to your Assets. 
      '
    end
  end

  def margin_text(margin)
    if margin > 30
      alert_info 'Margin% - Very well. If you are repaying Debt make sure you have bought Assets with this Debt. 
      Keep up the good work.
      Generated new Wealth to Income(both are for the period - from the date when you started
      measuring your Wealth up to now). This ratio shows how much you save and invest as % from your income.
      '
    elsif margin < 30 && margin > 10
      alert_info 'Margin% - You are able to save and invest a reasonable amount of your income. 
      If you are repaying Debt make sure that you have bought Assets with this Debt.
      Generated new Wealth to Income(both are for the period - from the date when you started
      measuring your Wealth up to now). This ratio shows how much you save and invest as % from your income.
      '
    elsif margin < 10 && margin > 0
      alert_info 'Margin% - You are not doing very well with saving and investing for now. Think about it.
      Generated new Wealth to Income(both are for the period - from the date when you started
      measuring your Wealth up to now). This ratio shows how much you save and invest as % from your income. 
      '
    elsif margin < 0
      alert_info 'Margin% - You are pushing you finances to the limit and over.  
      You are spending more than you can afford. Find ways to lower your Expenses or increase your Income.
      Generated new Wealth to Income(both are for the period - from the date when you started
      measuring your Wealth up to now). This ratio shows how much you save and invest as % from your income.
      '
    end
  end

  def alert_info(text)
    content_tag(:div, class: 'alert alert-info') do
      text
    end
  end
end
