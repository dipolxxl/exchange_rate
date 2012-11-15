namespace :currency do

  desc "Update|create the current exchange rates."
  task update: :environment do
    #CurrencyUpdater.update_current_month
    CurrencyUpdater.some
  end

end