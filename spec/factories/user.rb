FactoryBot.define do
  factory :user do
    name { "user_#{rand(9999)}" }
    sequence(:email) { |n| "example_#{n}@example.com" }
    after(:build) { |u| u.password_confirmation = u.password = "123456"}
  end
end
