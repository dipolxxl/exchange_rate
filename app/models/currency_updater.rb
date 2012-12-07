class CurrencyUpdater
  class << self

    def get_rates_in_xml(address)
      begin
        client = Savon::Client.new(address)
        response = client.request :web, :get_curs_on_date_xml,
                   body: {"On_date" => Date.today}
        response = response.xpath("//ValuteCursOnDate") if response.present?
      rescue
        puts "CurrencyUpdater.get_rates_in_xml has error! Check the incoming address " +
             "or internet connection. Expected 'WDSL' document."
      end
      response
    end

    def parsing_response_for_update(response)
      begin
        hash_with_rates = {}

        response.each do |current_rate|
          code = current_rate.xpath("VchCode").text
          course_raw = current_rate.xpath("Vcurs").text.to_f
          nom = current_rate.xpath("Vnom").text.to_i
          course = course_raw / nom

          hash_with_rates[code] = course
        end
      rescue
        puts "CurrencyUpdater.parsing_response_for_update has error! " +
             "No response or invalid response from the cbr.ru"
      end
      hash_with_rates
    end

    def parsing_response_for_create(response)
      begin
        hash_with_currencies = {}

        response.each do |current_rate|
          code = current_rate.xpath("VchCode").text
          name = current_rate.xpath("Vname").text.rstrip

          hash_with_currencies[code] = name
        end
      rescue
        puts "CurrencyUpdater.parsing_response_for_create has error! " +
             "No response or invalid response from the cbr.ru"
      end
      hash_with_currencies
    end

    def fill_table_currencies(hash_with_currencies)
      if hash_with_currencies.present?
        hash_with_currencies.each do |code, name|
          unless Currency.with_code(code).present?
            Currency.create(code: code, name: name)
          end
        end
      else
        puts "Error! No response from the cbr.ru"
      end
    end

    def update_rates(hash_with_rates)
      if hash_with_rates.present?
        date = Date.today.beginning_of_month
        hash_with_rates.each do |code, course|
          currency = Currency.with_code(code).first
          rate = currency.rates.where(month: date).first

          if rate.present?
            rate.update_attributes(course: course, month: date)
          else
            currency.rates.create(course: course, month: date)
          end
        end
      else
        puts "Error! No response from the cbr.ru"
      end
    end

    def update_current_month
      address = "http://www.cbr.ru/DailyInfoWebServ/DailyInfo.asmx?WSDL"
      response = get_rates_in_xml(address)

      hash_with_currencies = parsing_response_for_create(response)
      fill_table_currencies(hash_with_currencies)

      hash_with_rates = parsing_response_for_update(response)
      update_rates(hash_with_rates)
    end
  end
end