# encoding: UTF-8
require 'spec_helper'

describe CurrencyUpdater do
  describe ".get_rates_in_xml" do
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

  describe ".parsing_response_for_update" do
    it "should return empty hash for empty response" do
      hash = CurrencyUpdater.parsing_response_for_update("")
      hash.size.should == 0
    end

    it "should not return empty hash for valid response"
  end

  describe ".parsing_response_for_create" do
    it "should return empty hash for empty response" do
      hash = CurrencyUpdater.parsing_response_for_create("")
      hash.size.should == 0
    end

    it "should not return empty hash for valid response"
  end

  describe ".fill_table_currencies" do
    before do
      Currency.delete_all
    end

    it "should fill empty table from incoming hash" do
      hash = {
              "BYR" => "Белорусский рубль",
              "EUR" => "Евро",
              "USD" => "Доллар США"
             }
      expect{CurrencyUpdater.fill_table_currencies(hash)}.
                                    to change{Currency.count}.from(0).to(3)
    end

    context "should" do
      before do
        # fill the table with initial data
        hash = {
                "BYR" => "Белорусский рубль",
                "EUR" => "Евро",
                "USD" => "Доллар США"
               }
        CurrencyUpdater.fill_table_currencies(hash)
      end

      context "add missing currencies" do
        it "if it's present in cbr.ru response" do
          new_hash = {
                      "BYR" => "Белорусский рубль",
                      "EUR" => "Евро",
                      "JPY" => "Японская иена"
                     }
          expect{CurrencyUpdater.fill_table_currencies(new_hash)}.
                                      to change{Currency.count}.from(3).to(4)
        end
      end    

      context "not fill table" do
        it "if it's contain this currencies" do
          hash = {"BYR" => "Белорусский рубль"}
          expect{CurrencyUpdater.fill_table_currencies(hash)}.
                                                to_not change{Currency.count}
        end

        it "if incoming hash is empty" do
          expect{CurrencyUpdater.fill_table_currencies({})}.
                                                to_not change{Currency.count}
        end
      end
    end    
  end

  describe ".update_rates" do
    before do
      Currency.delete_all
      Rate.delete_all
      Currency.create(code: "USD", name: "Доллар США")
      date = Date.today.beginning_of_month
      Currency.first.rates.create(course: 31.6, month:date)
    end

    context "should not update rates values" do
      it "for empty incoming hash" do
        expect{CurrencyUpdater.update_rates({})}.
                          to_not change{Currency.first.rates.first.course}
      end
    end

    context "should update rates values" do
      it "from incoming hash" do
        hash = {"USD"=>32.0}
        expect{CurrencyUpdater.update_rates(hash)}.
          to change{Currency.first.rates.first.course}.from(31.6).to(32.0)
      end
    end
  end

  describe ".update_current_month" do
    pending     
  end
end
