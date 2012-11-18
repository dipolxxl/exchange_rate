# encoding: UTF-8
require 'spec_helper'
require 'rake'

describe CurrencyUpdater do

  context ".get_rates_in_xml" do
    it "should return nil for empty query params" do
      CurrencyUpdater.get_rates_in_xml("").should be_nil
    end

    it "should return nil for invalid query params" do
      address = "http://www.cbr.ru/DailyInfoWebServ/"
      CurrencyUpdater.get_rates_in_xml(address).should be_nil
    end

    it "should not return nil for valid query params" do
      address = "http://www.cbr.ru/DailyInfoWebServ/DailyInfo.asmx?WSDL"
      CurrencyUpdater.get_rates_in_xml(address).should_not be_nil
    end
  end

  context ".parsing_response_for_update" do
    it "should return nil for empty response" do
      hash = CurrencyUpdater.parsing_response_for_update("")
      hash.size.should == 0
    end

    it "should not return nil for valid response"
  end

  context ".parsing_response_for_create" do
    it "should return nil for empty response" do
      hash = CurrencyUpdater.parsing_response_for_create("")
      hash.size.should == 0
    end

    it "should not return nil for valid response"
  end

  context ".fill_table_currencies" do
    it "should fill table currencies correct values" do
      hash = {"BYR" => "Белорусский рубль", "EUR" => "Евро", "USD" => "Доллар США"}
      expect{CurrencyUpdater.fill_table_currencies(hash)}.to change{Currency.count}
    end

    it "should not fill table for empty incoming hash" do
      hash = {}
      expect{CurrencyUpdater.fill_table_currencies(hash)}.to_not change{Currency.count}
    end
  end

  context "methods working with db" do

    # before :each do
    #   Rake::Task['test:prepare'].invoke
    # end    

    context ".update_rates" do
      it "should return nil for empty incoming argument" do
        hash_with_rates = {}
        CurrencyUpdater.update_rates(hash_with_rates).should be_nil
      end
    end

    context ".update_current_month" do
      pending
    end
  end 
end
