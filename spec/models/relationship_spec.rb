require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:user) { FactoryGirl.build(:user) }
  let!(:relationship) { FactoryGirl.build(:relationship) }
  describe 'table association' do
    it { should belong_to(:follower) }
    it { should belong_to(:followed) }
  end
end
