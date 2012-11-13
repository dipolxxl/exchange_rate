class CurrenciesController < ApplicationController
  before_filter :checking_the_date
  respond_to :json

  def checking_the_date
    begin
      @date = params[:month].presence.try(:to_date) || Date.today
    rescue
      # ToDo: подумать над отловом типа ошибок!
      render :text => "Invalid date format! Expected 'YYYY-MM-DD'."
    end
  end

  # GET /currencies.json?month=  or  GET /currencies.json?month=2012-12-21
  def index
    # ToDo: подумать над лишними обращениями к бд
    @rates = Rate.at_month(@date)
    respond_with @rates
  end

  # GET /currencies/USD.json?month=2012-10-01
  def show
    @currency = Currency.at_code(params[:id]).first.rates.at_month(@date)
    respond_with @currency
  end
end
