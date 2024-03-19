# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# create users
4.times do |i|
  user_number = i + 1
  email = "test#{user_number}@test.com"
  password = "123456"
  username = "user#{user_number}"
  display_name = "userD#{user_number}"

  # create users if not already
  user = User.find_or_initialize_by(email: email)

  if user.new_record?
    user.password = password
    user.username = username
    user.display_name = display_name

    # Path to the profile picture
    path_to_image = Rails.root.join('app', 'assets', 'images', 'profile_pictures', "user#{user_number}.png")
    # Attach the profile picture
    user.avatar.attach(io: File.open(path_to_image), filename: "user#{user_number}.png", content_type: 'image/png')

    user.save!
  end
end

# create follows. all users follow other users except themselves
all_users = User.all.to_a

all_users.each do |follower_user|
  users_to_be_followed = all_users - [follower_user]

  users_to_be_followed.each do |user_to_be_followed|
    unless Follow.exists?(follower: follower_user, followed: user_to_be_followed)
      Follow.create(follower: follower_user, followed: user_to_be_followed)

      # create channels/subscriptions for default users
      follower_channel_subscriptions = Subscription.where(user: follower_user)
      followed_channel_subscriptions = Subscription.where(user: user_to_be_followed)

      common_channels = follower_channel_subscriptions.pluck(:channel_id) & followed_channel_subscriptions.pluck(:channel_id)
      already_in_conversation = common_channels.any?

      unless already_in_conversation
        channel = Channel.create()
        Subscription.create(user: follower_user, channel_id: channel.id)
        Subscription.create(user: user_to_be_followed, channel_id: channel.id)
      end
    end
  end
end

# create tweets and tweet activities
4.times do |i|
  creator_user = User.find(i+1)
  created_tweet = Tweet.create(user: creator_user, body: "tweet #{i + 1}")

  tweet_activities = creator_user.followers.map do |follower|
    TweetActivity.find_or_create_by(activity_creator: creator_user, activity_viewer: follower, tweet: created_tweet, activity: "tweeted")
  end
end

