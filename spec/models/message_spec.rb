require 'rails_helper'

RSpec.describe Message, type: :model do
  it { should belong_to(:sender).class_name("User") }
  it { should validate_presence_of :body }

  it { should belong_to(:conversation) }
end
