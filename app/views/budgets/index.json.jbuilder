json.array!(@budgets) do |budget|
  json.extract! budget, :id, :account_id, :group_id, :budget_date, :ammount, :text, :wunit
  json.url budget_url(budget, format: :json)
end
