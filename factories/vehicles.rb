FactoryGirl.define do
  factory :vehicle do
    sequence(:vin) {|n| "#{n.to_s*17}"} 
    make "Lamborghini"
    model "Aventador"
    transmission_type "AUTOMATED_MANUAL"
    engine_type "gas"
    engine_cylinders 12
    engine_size 6.5

    factory :vehicle_with_everything do
      after(:create) do |vehicle, evaluator|
        FactoryGirl.create(:colors, 2, vehicle:vehicle)
        FactoryGirl.create(:options, 2, vehicle:vehicle)
        FactoryGirl.create(:styles, 2, vehicle:vehicle)
      end
    end


  end
end
