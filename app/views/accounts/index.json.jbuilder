json.array!(@accounts) do |account|
  json.extract! account, :id, :name, :group_id, :report_id
  json.url account_url(account, format: :json)
end
