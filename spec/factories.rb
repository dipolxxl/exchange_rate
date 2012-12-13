# if name not 'currency' must be the same "factory :not_currency, class: Currency do" 
FactoryGirl.define do
  factory :currency do
    sequence(:code) {|n| "USD#{n}" }
    #code  "USD"
    name  "US Dolar"
  end
end

FactoryGirl.define do
  factory :rate do
    course      30.3
    month       "2012-12-01" 
    association :currency
  end
end