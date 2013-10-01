FactoryGirl.define do
  factory :vehicle do
    sequence(:vin) {|n| "#{n.to_s*17}"} 
    make "Lamborghini"
    model "Aventador"
    year 2013
    transmission_type "AUTOMATED_MANUAL"
    engine_type "gas"
    engine_cylinders 12
    engine_size 6.5
    trim "LP 700-4"

  end
end
