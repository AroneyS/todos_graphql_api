FactoryBot.define do
  factory :todo_list do
    sequence(:title) { |n| "#{Faker::Lorem.word}-#{n}"}

    factory :todo_list_with_items do
      transient do
        item_count { 10 }
      end

      after(:create) do |todo_list, evaluator|
        create_list(:item, evaluator.item_count, todo_list: todo_list)
      end
    end
  end

  factory :item do
    sequence(:name) { |n| "Item name #{n}"}
    done { false }

    todo_list
  end
end