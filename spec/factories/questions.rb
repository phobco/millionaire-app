FactoryBot.define do
  factory :question do
    sequence(:text) { |n| "Сколько будет 1 + #{n}?" }

    sequence(:level) { |n| n % 15}

    answer1 {"#{rand(999)}"}
    answer2 {"#{rand(999)}"}
    answer3 {"#{rand(999)}"}
    answer4 {"#{rand(999)}"}
  end
end
