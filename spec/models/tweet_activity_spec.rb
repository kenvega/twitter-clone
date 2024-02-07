require 'rails_helper'

RSpec.describe TweetActivity, type: :model do
  it { should belong_to(:activity_viewer).class_name("User") }
  it { should belong_to(:activity_creator).class_name("User") }
  it { should belong_to :tweet }

  it { should validate_presence_of(:activity) }
  it { should validate_inclusion_of(:activity).in_array(TweetActivity::ACTIVITIES) }
end
