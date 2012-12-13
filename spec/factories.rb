# if name not 'currency' must be the same "factory :not_currency, class: Currency do" 
FactoryGirl.define do
  factory :currency do
    sequence(:code) {|n| "USD#{n}" }
    name  "US Dollar"
  end
end

FactoryGirl.define do
  factory :rate do
    course      30.3
    month       "2012-10-01" 
    association :currency, code: "USD"
  end
end

FactoryGirl.define do
  factory :rate_sequence, parent: :rate, class: Rate do
    sequence(:course) {|n| (30.3 + n) }
    association :currency
  end
end