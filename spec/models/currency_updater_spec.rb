require 'spec_helper'

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
      CurrencyUpdater.fill_table_currencies(hash)}.to change{Currency.count}
    end
  end

end