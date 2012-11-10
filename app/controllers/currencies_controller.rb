class CurrenciesController < ApplicationController

  respond_to :json

  # GET /currencies.json?month=  or  GET /currencies.json?month=2012-12-21
  def index
    date = params[:month] == "" ? Time.now.to_date : params[:month].to_date
    @rates = Rate.at_month(date)
    respond_with @rates
  end

  # GET /currencies/USD.json?month=2012-10-01
  def show
    @currency = Currency.at_code(params[:id]).first.rates.at_month(params[:month].to_date)
    respond_with @currency
  end
end
