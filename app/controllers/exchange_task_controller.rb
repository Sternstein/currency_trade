require 'sidekiq/api'

class ExchangeTaskController < ApplicationController
  before_action :authenticate_user!

  def index
    query = Sidekiq::Queue.new 
    jobs = query.select do |job|
      job.args[0] == current_user.id
    end.map
    query_retry = Sidekiq::ScheduledSet.new
    jobs_r = query_retry.select do |job|
      job.args[0] == current_user.id
    end.map
    @jobs = jobs_r
  end

  def new
    accounts_raw = current_user.accounts
    @accounts = accounts_raw.map{|s| [Currency.find_by(id: s.currency_id).name, s.id]}
    @conditions = [[">=", 1],["=<", 2]]
  end
 
  def delete
    jid = params[:jid]
    query_retry = Sidekiq::ScheduledSet.new
    query_retry.select do |job|
      if job.args[0] == current_user.id
        job.delete if job.jid == jid
      end
    end
    redirect_to exchange_tasks_path
  end

  def create
    user_id = current_user.id
    account_id1 = params[:account_id1]
    account_id2 = params[:account_id2]
    rate_limit = params[:rate_limit]
    condition = params[:condition]
    amount = params[:amount]
    date_until = date_from_params(params, :date_until)
    if account_id1 == account_id2
      flash[:alert] = "You cann't do exchange between the same account! Please select two different accounts"
      redirect_to exchange_tasks_new_path
    elsif account_id1 != nil and account_id2 != nil and rate_limit.length > 0  and condition != nil and amount.length > 0
      ExchangeWorker.perform_async(user_id, account_id1, account_id2, amount, rate_limit, condition, date_until)
      redirect_to exchange_tasks_path
    else
      msg = ""
      if rate_limit.length == 0
        msg = msg + "Rate limit can not be blank!\n"
      end
      if condition.length == 0
        msg = msg + "Condition can not be blank!\n"
      end
      if amount.length == 0
        msg = msg + "Amount can not be blank!\n"
      end
      flash[:alert] = msg
      redirect_to exchange_tasks_new_path
    end
  end

  private

  def date_from_params(params, date_key)
    date_keys = params.keys.select { |k| k.to_s.match?(date_key.to_s) }.sort
    date_array = params.values_at(*date_keys).map(&:to_i)
    DateTime.civil(*date_array)
  end


end
