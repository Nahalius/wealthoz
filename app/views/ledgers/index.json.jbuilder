json.array!(@ledgers) do |ledger|
  json.extract! ledger, :id, :account_id, :wunit_id, :post_date, :ammount, :text, :quantity
  json.url ledger_url(ledger, format: :json)
end
