FactoryBot.define do
  factory :event do
    association :user
    title { 'bbq for my friends' }
    address { 'Москва' }
    datetime { DateTime.parse('10.10.2025') }
  end
end
