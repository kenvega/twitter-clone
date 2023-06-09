require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:tweets).dependent(:destroy) }

  it { should have_many(:likes).dependent(:destroy)}
  it { should have_many(:liked_tweets).through(:likes).source(:tweet) }

  it { should have_many(:bookmarks).dependent(:destroy)}
  it { should have_many(:bookmarked_tweets).through(:bookmarks).source(:tweet) }

  it { should validate_uniqueness_of(:username).case_insensitive.allow_blank }

  describe "#set_display_name" do
    context "when display_name is set" do
      it "does not change the display_name" do
        user = build(:user, username: "john_doe", display_name: "John doe")
        user.save
        expect(user.reload.display_name).to eq("John doe")
      end
    end

    context "when display_name is not set" do
      it "humanizes the previously set username" do
        user = build(:user, username: "john_doe", display_name: nil)
        user.save
        expect(user.reload.display_name).to eq("John doe")
      end
    end
  end
end
