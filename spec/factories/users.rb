FactoryBot.define do
  factory :user do
    name {"User_#{rand(999)}"}

    sequence(:email) { |n| "test_#{n}@test.com" }

    is_admin { false }
    balance { 0 }

    after(:build) { |u| u.password_confirmation = u.password = "123123"}
  end
end
