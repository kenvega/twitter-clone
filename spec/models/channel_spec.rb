require 'rails_helper'

RSpec.describe Channel, type: :model do
  it { should have_many(:subscriptions) }
  it { should have_many(:users).through(:subscriptions) }

  it { should have_many(:messages) }
end
