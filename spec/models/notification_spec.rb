require 'rails_helper'

RSpec.describe Notification, type: :model do
  it { should belong_to(:notifier).class_name("User") }
  it { should belong_to(:notified).class_name("User") }

  it { should belong_to(:tweet).optional }

  it { should validate_presence_of :action }
  it { should validate_inclusion_of(:action).in_array(Notification::ACTIONS)}
end
