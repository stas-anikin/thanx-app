require 'rails_helper'

RSpec.describe Reward, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:points_cost) }
    it { should validate_numericality_of(:points_cost).is_greater_than(0) }
  end

  describe "associations" do
    it { should have_many(:redemptions).dependent(:destroy) }
  end

  describe "scopes" do
    let!(:active_reward) { create(:reward, is_active: true) }
    let!(:inactive_reward) { create(:reward, is_active: false) }

    describe ".active" do
      it "returns only active rewards" do
        expect(Reward.active).to include(active_reward)
        expect(Reward.active).not_to include(inactive_reward)
      end
    end

    describe ".inactive" do
      it "returns only inactive rewards" do
        expect(Reward.inactive).to include(inactive_reward)
        expect(Reward.inactive).not_to include(active_reward)
      end
    end
  end

  describe "#available?" do
    it "returns true for active rewards" do
      reward = build(:reward, is_active: true)
      expect(reward.available?).to be true
    end

    it "returns false for inactive rewards" do
      reward = build(:reward, is_active: false)
      expect(reward.available?).to be false
    end
  end

  describe "#can_be_redeemed_by?" do
    let(:reward) { create(:reward, points_cost: 100) }
    let(:user_with_points) { create(:user, points_balance: 200) }
    let(:user_without_points) { create(:user, points_balance: 50) }

    it "returns true for active rewards with sufficient points" do
      expect(reward.can_be_redeemed_by?(user_with_points)).to be true
    end

    it "returns false for active rewards without sufficient points" do
      expect(reward.can_be_redeemed_by?(user_without_points)).to be false
    end

    it "returns false for inactive rewards regardless of points" do
      reward.update(is_active: false)
      expect(reward.can_be_redeemed_by?(user_with_points)).to be false
    end
  end
end
