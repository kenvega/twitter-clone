FactoryBot.define do
  factory :notification do
    notifier { nil }
    notified { nil }
    tweet { nil }
    action { "MyString" }
  end
end
