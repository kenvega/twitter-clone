FactoryBot.define do
  factory :notification do
    notifier { create(:user) }
    notified { create(:user) }
    tweet
    action { Notification::ACTIONS.sample }
  end
end
