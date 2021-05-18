FactoryBot.define do
  factory :event do
    title { "event_#{rand(999)}" }
    address { 'Moscow' }
    datetime { 1.days.after }
  end
end
