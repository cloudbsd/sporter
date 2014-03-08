json.array!(@transactions) do |transaction|
  json.extract! transaction, :id, :user_id, :action, :amount
  json.url transaction_url(transaction, format: :json)
end
