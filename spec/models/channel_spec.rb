require 'rails_helper'

RSpec.describe Channel, type: :model do
  it { should have_many(:subscribers) }
  it { should have_many(:users).through(:subscribers) }

  it { should have_many(:messages) }
end
