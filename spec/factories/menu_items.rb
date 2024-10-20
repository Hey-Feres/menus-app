FactoryBot.define do
  factory :menu_item do
    association :menu
    name { "Sample Menu Item" }
    price_cents { 1_000 }
    quantity { "400g" }
    description { "Delicious sample item." }
  end
end
