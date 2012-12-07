# encoding: UTF-8
require 'spec_helper'

describe CurrencyUpdater do
  describe ".get_rates_in_xml" do
    it "should return nil for empty query params" do
      VCR.use_cassette('empty_request_in_the_cbr') do
        CurrencyUpdater.get_rates_in_xml("").should be_nil
      end
    end

    it "should return nil for invalid query params" do
      VCR.use_cassette('invalid_request_in_the_cbr') do
        CurrencyUpdater.get_rates_in_xml(
          "http://www.cbr.ru/DailyInfoWebServ/").should be_nil
      end
    end

    it "should not return nil for valid query params" do
      VCR.use_cassette('valid_request_in_the_cbr') do
        CurrencyUpdater.get_rates_in_xml(
          "http://www.cbr.ru/DailyInfoWebServ/DailyInfo.asmx?WSDL").should be
      end
    end
  end

  describe ".parsing_response_for_update" do
    it "should return empty hash for empty response" do
      CurrencyUpdater.parsing_response_for_update("").should eql(Hash.new)
    end

    it "should return empty hash for invalid response" do
      # парсинг перенести в хелпер  
      # xml = test_xml("./spec/models/invalid_raw_response.xml")
      xml = (Nokogiri::XML::Document.parse(
        File.read("./spec/models/invalid_raw_response.xml"), nil, "UTF-8"
      ).xpath("//ValuteCursOnDate"))

      CurrencyUpdater.parsing_response_for_update(xml).should eql(Hash.new)
    end    

    it "should return valid hash for valid response" do
      xml = (Nokogiri::XML::Document.parse(
        File.read("./spec/models/raw_response.xml"), nil, "UTF-8"
      ).xpath("//ValuteCursOnDate"))

      CurrencyUpdater.parsing_response_for_update(xml).should ==
        {"USD" => 32.0}
    end
  end

  describe ".parsing_response_for_create" do
    it "should return empty hash for empty response" do
      CurrencyUpdater.parsing_response_for_create("").should eql(Hash.new)
    end

    it "should return empty hash for invalid response" do
      xml = (Nokogiri::XML::Document.parse(
        File.read("./spec/models/invalid_raw_response.xml"), nil, "UTF-8"
      ).xpath("//ValuteCursOnDate"))

      CurrencyUpdater.parsing_response_for_create(xml).should eql(Hash.new)
    end   

    it "should return valid hash for valid response" do
      xml = (Nokogiri::XML::Document.parse(
        File.read("./spec/models/raw_response.xml"), nil, "UTF-8"
      ).xpath("//ValuteCursOnDate"))

      CurrencyUpdater.parsing_response_for_create(xml).should ==
        {"USD" => "Доллар США"}
    end
  end

  describe ".fill_table_currencies" do
    before do
      Currency.delete_all
      @hash = {
              "BYR" => "Белорусский рубль",
              "EUR" => "Евро",
              "USD" => "Доллар США"
             }
    end

    it "should fill empty table from incoming hash" do
      expect{CurrencyUpdater.fill_table_currencies(@hash)}.
        to change{Currency.count}.from(0).to(3)
    end

    context "should" do
      before do
        CurrencyUpdater.fill_table_currencies(@hash)
      end

      context "add missing currencies" do
        it "if it's present in cbr.ru response" do
          expect{CurrencyUpdater.fill_table_currencies(
            "BYR" => "Белорусский рубль",
            "EUR" => "Евро",
            "JPY" => "Японская иена"
          )}.to change{Currency.count}.from(3).to(4)
        end
      end    

      context "not fill table" do
        it "if it's contain this currencies" do
          expect{CurrencyUpdater.fill_table_currencies(
            "BYR" => "Белорусский рубль"
          )}.to_not change{Currency.count}
        end

        it "if incoming hash is empty" do
          expect{CurrencyUpdater.fill_table_currencies({})
            }.to_not change{Currency.count}
        end
      end
    end    
  end

  describe ".update_rates" do
    before do
      Currency.delete_all
      Rate.delete_all
      currency = Currency.create(code: "USD", name: "Доллар США")
      currency.rates.create(
        course: 31.6, 
        month:  Date.today.beginning_of_month
      )
    end

    context "should not update rates values" do
      it "for empty incoming hash" do
        expect{CurrencyUpdater.update_rates({})}.
                          to_not change{Currency.first.rates.first.course}
      end
    end

    context "should update rates values" do
      it "from valid incoming hash" do
        expect{CurrencyUpdater.update_rates({"USD"=>32.0})}.
          to change{Currency.first.rates.first.course}.from(31.6).to(32.0)
      end
    end
  end

  describe ".update_current_month" do
    pending     
  end
end
