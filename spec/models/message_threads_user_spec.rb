require 'rails_helper'

RSpec.describe MessageThreadsUser, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:message_thread) }
end
