class CurrencyUpdater
  class << self

    def get_rates_in_xml(address)
      client = Savon::Client.new(address)
      response = client.request :web, :get_curs_on_date_xml, body: {"On_date" => Date.today}
      response.xpath("//ValuteCursOnDate") #if response.present?
      puts "get_rates_in_xml(address)"
      response
    end

    def parsing_response_for_update(incoming_response)
      response = incoming_response #get_rates_in_xml
      
      if response.present?
        hash_with_rates = {}
        puts '4'
        response.each do |current_rate|
          code = current_rate.xpath("VchCode").text
          course_raw = current_rate.xpath("Vcurs").text.to_f
          nom = current_rate.xpath("Vnom").text.to_i
          course = course_raw / nom

          hash_with_rates[code] = course
        end
      else
        puts "Error! No response from the cbr.ru"
      end
      hash_with_rates        
    end


    def parsing_response_for_create(incoming_response)
      response = incoming_response #get_rates_in_xml
      
      if response.present?
        hash_with_currencies = {}
        response.each do |current_rate|
          code = current_rate.xpath("VchCode").text
          name = current_rate.xpath("Vname").text.rstrip!

          hash_with_currencies[code] = name
        end
      else
        puts "Error! No response from the cbr.ru"
      end
      hash_with_currencies       
    end

    def fill_table_currencies(hash_with_currencies)
      if hash_with_currencies.present?
        hash_with_currencies.each do |code, name|
          Currency.create(code: code, name: name)
        end
      else
        puts "Error! No response from the cbr.ru"
      end
    end

    def update_rates(hash_with_rates)
      if hash_with_rates.present?
        date = Date.today.beginning_of_month
        hash_with_rates.each do |code, course|
          currency = Currency.where(code: code).first
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
      puts '1'
      address = "http://www.cbr.ru/DailyInfoWebServ/DailyInfo.asmx?WSDL"
      puts '2'
      response = self.get_rates_in_xml(address)
      puts '3'

      if Currency.count == 0
        hash_with_currencies = self.parsing_response_for_create(response)
        self.fill_table_currencies(hash_with_currencies)
      else
        hash_with_rates = self.parsing_response_for_update(response)
        self.update_rates(hash_with_rates)
      end
    end
  end
end




# namespace :currency do

#   desc "Getting exchange rates in xml from the cbr.ru"
#   task :get_rates_in_xml => :environment do
#     client = Savon::Client.new("http://www.cbr.ru/DailyInfoWebServ/DailyInfo.asmx?WSDL")
#     response = client.request :web, :get_curs_on_date_xml, body: {"On_date" => Date.today}
#     @get_curs_on_date = response.xpath("//ValuteCursOnDate") if response.present?
#   end

#   desc "Parsing response from cbr.ru for ':update_rates'."
#   task :parsing_response_for_update => :get_rates_in_xml do
#     if @get_curs_on_date.present?
#       @hash_with_rates = {}
#       @get_curs_on_date.each do |current_rate|
#         code = current_rate.xpath("VchCode").text
#         course_raw = current_rate.xpath("Vcurs").text.to_f
#         nom = current_rate.xpath("Vnom").text.to_i
#         course = course_raw / nom

#         @hash_with_rates[code] = course
#       end
#     else
#       puts "Error! No response from the cbr.ru"
#     end
#   end

#   desc "Parsing response from cbr.ru for ':fill_currency.'"
#   task :parsing_response_for_create => :get_rates_in_xml do
#     if @get_curs_on_date.present?
#       @hash_with_currencies = {}
#       @get_curs_on_date.each do |current_rate|
#         code = current_rate.xpath("VchCode").text
#         name = current_rate.xpath("Vname").text.rstrip!

#         @hash_with_currencies[code] = name
#       end
#     else
#       puts "Error! No response from the cbr.ru"
#     end
#   end

#   desc "Update|create the current exchange rates."
#   task :update_rates => :parsing_response_for_update do
#     if @hash_with_rates.present?
#       date = Date.today.beginning_of_month
#       @hash_with_rates.each do |code, course|
#         currency = Currency.where(code: code).first
#         rate = currency.rates.where(month: date).first

#         if rate.present?
#           rate.update_attributes(course: course, month: date)
#         else
#           currency.rates.create(course: course, month: date)
#         end
#       end
#     else
#       puts "Error! No response from the cbr.ru"
#     end
#   end

#   desc "Fill 'Currency' by data from cbr.ru (for initialize)."
#   task :fill_db_currency => :parsing_response_for_create do
#     if @hash_with_currencies.present?
#       Rake::Task['db:reset'].invoke
#       @hash_with_currencies.each do |code, name|
#         Currency.create(code: code, name: name)
#       end
#     else
#       puts "Error! No response from the cbr.ru"
#     end
#   end
# end