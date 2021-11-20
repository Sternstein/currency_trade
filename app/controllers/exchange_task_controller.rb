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
    @conditions = [[1,">="],[2,"=<"]]
  end
  
  def create
    user_id = current_user.id
    account_id1 = params[:account_id1]
    account_id2 = params[:account_id2]
    rate_limit = params[:rate_limit]
    condition = params[:condition]
    amount = params[:amount]
    ExchangeWorker.perform_async(user_id, account_id1, account_id2, amount, rate_limit, condition)
    redirect_to exchange_tasks_path
  end  


end
