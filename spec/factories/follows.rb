FactoryBot.define do
  factory :follow do
    follower do
      create(:user)
    end
    followed do
      create(:user)
    end
  end
end
