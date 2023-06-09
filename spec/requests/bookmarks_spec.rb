require 'rails_helper'

RSpec.describe "Bookmarks", type: :request do
  let(:user) { create(:user) }
  let(:tweet) { create(:tweet) }

  before { sign_in user }

  describe "POST create" do
    it "creates a new Bookmark" do
      expect do
        post tweet_bookmarks_path(tweet)
      end.to change { Bookmark.count }.by(1)
    end
  end

  describe "DELETE destroy" do
    it "deletes a Bookmark" do
      bookmark = create(:bookmark, user: user, tweet: tweet)
      expect do
        delete tweet_bookmark_path(tweet, bookmark)
      end.to change { Bookmark.count }.by(-1)
    end
  end
end
