class ExchangeWorker
  include Sidekiq::Worker

  def perform(user_id, account_id1, account_id2, amount, rate_for_exchange, condition, date_until_string)
    account1 = Account.find_by(id: account_id1)
    account2 = Account.find_by(id: account_id2) 
    amount1 = account1.amount
    amount2 = account2.amount
    currency_id = account2.currency_id
    currency_id_from = account1.currency_id
    currency_from = Currency.find_by(id: currency_id_from)
    currency_from_name = currency_from.name
    currency = Currency.find_by(id: currency_id)
    currency_name = currency.name
    request_uri = "https://www.alphavantage.co/query?function=CURRENCY_EXCHANGE_RATE&from_currency="+currency_from_name+"&to_currency="+currency_name+"&apikey="+"VBSRNKH2E0WYL5R2"
    uri = URI(request_uri)
    res = Net::HTTP.get_response(uri)
    hash = JSON.parse(res.body)
    rate_f = hash["Realtime Currency Exchange Rate"]["5. Exchange Rate"]
    rate_s = rate_f.to_s
    amount_currency = BigDecimal(amount) * BigDecimal(rate_s)
    amount_on_first = amount1 - BigDecimal(amount)
    if condition == 1
      condition_for_exchange = BigDecimal(rate_for_exchange) >= BigDecimal(rate_s)
    else
      condition_for_exchange = BigDecimal(rate_for_exchange) <= BigDecimal(rate_s)
    end
    date_time_now = DateTime.now
    date_until = date_until_string.to_datetime
    if amount_currency > BigDecimal(0) and amount_on_first >= BigDecimal(0) and condition_for_exchange and date_until > date_time_now
      account2.amount = amount2 + amount_currency
      account1.amount = amount1 - BigDecimal(amount)
      account1.save()
      account2.save()
    elsif date_until > date_time_now
      ExchangeWorker.perform_at(30.seconds.from_now, user_id, account_id1, account_id2, amount, rate_for_exchange, condition, date_until_string)
    end
  end
end
