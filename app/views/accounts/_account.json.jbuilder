json.extract! account, :id, :user_id, :currency_id, :amount, :created_at, :updated_at
json.url account_url(account, format: :json)
