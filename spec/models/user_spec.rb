require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    subject { create(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_numericality_of(:points_balance).is_greater_than_or_equal_to(0) }
  end

  describe "associations" do
    it { should have_many(:redemptions).dependent(:destroy) }
  end

  describe "#add_points" do
    let(:user) { create(:user, points_balance: 100) }

    it "adds points to the user's balance" do
      expect { user.add_points(50) }.to change { user.points_balance }.from(100).to(150)
    end
  end

  describe "#deduct_points" do
    let(:user) { create(:user, points_balance: 100) }

    it "deducts points from the user's balance" do
      expect { user.deduct_points(50) }.to change { user.points_balance }.from(100).to(50)
    end

    it "raises an error when there are insufficient points" do
      expect { user.deduct_points(150) }.to raise_error(User::InsufficientPointsError)
    end
  end

  describe "#has_sufficient_points?" do
    let(:user) { create(:user, points_balance: 100) }

    it "returns true when user has enough points" do
      expect(user.has_sufficient_points?(50)).to be true
    end

    it "returns true when user has exactly the amount" do
      expect(user.has_sufficient_points?(100)).to be true
    end

    it "returns false when user has insufficient points" do
      expect(user.has_sufficient_points?(150)).to be false
    end
  end

  describe "#active_redemptions" do
    let(:user) { create(:user, :with_points) }
    let!(:pending_redemption) { create(:redemption, user: user, status: 'pending') }
    let!(:completed_redemption) { create(:redemption, user: user, status: 'completed') }

    it "returns only pending redemptions" do
      expect(user.active_redemptions).to include(pending_redemption)
      expect(user.active_redemptions).not_to include(completed_redemption)
    end
  end

  describe "#completed_redemptions" do
    let(:user) { create(:user, :with_points) }
    let!(:pending_redemption) { create(:redemption, user: user, status: 'pending') }
    let!(:completed_redemption) { create(:redemption, user: user, status: 'completed') }

    it "returns only completed redemptions" do
      expect(user.completed_redemptions).to include(completed_redemption)
      expect(user.completed_redemptions).not_to include(pending_redemption)
    end
  end
end
