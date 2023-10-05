require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:tweets).dependent(:destroy) }

  it { should have_many(:likes).dependent(:destroy)}
  it { should have_many(:liked_tweets).through(:likes).source(:tweet) }

  it { should have_many(:bookmarks).dependent(:destroy)}
  it { should have_many(:bookmarked_tweets).through(:bookmarks).source(:tweet) }

  it { should have_many(:retweets).dependent(:destroy)}
  it { should have_many(:retweeted_tweets).through(:retweets).source(:tweet) }

  it { should have_many(:views) } # if the user is deleted the views still count
  it { should have_many(:viewed_tweets).through(:views).source(:tweet) }

  it { should have_many(:given_follows).with_foreign_key(:follower_id).class_name("Follow") }
  it { should have_many(:followed_users).through(:given_follows).source(:followed) }
  it { should have_many(:received_follows).with_foreign_key(:followed_id).class_name("Follow") }
  it { should have_many(:followers).through(:received_follows).source(:follower) }

  it { should have_many(:messages) }

  it { should have_and_belong_to_many(:message_threads)}

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
