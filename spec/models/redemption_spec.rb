require 'rails_helper'

RSpec.describe Redemption, type: :model do
  describe "validations" do
    it { should validate_inclusion_of(:status).in_array(%w[pending completed cancelled]) }
    it { should validate_numericality_of(:points_spent).is_greater_than(0).allow_nil }
  end

  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:reward) }
  end

  describe "callbacks" do
    describe "before_validation" do
      let(:reward) { create(:reward, points_cost: 150) }
      let(:user) { create(:user, :with_points) }

      it "sets points_spent from reward if not provided" do
        redemption = build(:redemption, user: user, reward: reward, points_spent: nil)
        redemption.valid?
        expect(redemption.points_spent).to eq(150)
      end
    end

    describe "after_create" do
      let(:reward) { create(:reward, points_cost: 150) }
      let(:user) { create(:user, points_balance: 200) }

      it "deducts points from user" do
        expect {
          create(:redemption, user: user, reward: reward)
        }.to change { user.reload.points_balance }.by(-150)
      end
    end
  end

  describe "custom validations" do
    describe "#user_has_sufficient_points" do
      let(:user) { create(:user, points_balance: 100) }
      let(:expensive_reward) { create(:reward, points_cost: 150) }
      let(:cheap_reward) { create(:reward, points_cost: 50) }

      it "is valid when user has sufficient points" do
        redemption = build(:redemption, user: user, reward: cheap_reward)
        expect(redemption).to be_valid
      end

      it "is invalid when user has insufficient points" do
        redemption = build(:redemption, user: user, reward: expensive_reward)
        expect(redemption).not_to be_valid
        expect(redemption.errors[:base]).to include("Insufficient points")
      end
    end

    describe "#reward_is_active" do
      let(:user) { create(:user, :with_points) }
      let(:active_reward) { create(:reward, is_active: true) }
      let(:inactive_reward) { create(:reward, is_active: false) }

      it "is valid with active reward" do
        redemption = build(:redemption, user: user, reward: active_reward)
        expect(redemption).to be_valid
      end

      it "is invalid with inactive reward" do
        redemption = build(:redemption, user: user, reward: inactive_reward)
        expect(redemption).not_to be_valid
        expect(redemption.errors[:reward]).to include("is not available")
      end
    end
  end

  describe "#complete!" do
    let(:user) { create(:user, :with_points) }
    let(:reward) { create(:reward, points_cost: 100) }
    let(:redemption) { create(:redemption, user: user, reward: reward) }

    it "updates status to completed" do
      expect { redemption.complete! }.to change { redemption.status }.from("pending").to("completed")
    end
  end

  describe "#cancel!" do
    let(:user) { create(:user, points_balance: 150) }
    let(:reward) { create(:reward, points_cost: 100) }

    context "with pending status" do
      let(:redemption) { create(:redemption, user: user, reward: reward, status: "pending") }

      it "updates status to cancelled" do
        expect { redemption.cancel! }.to change { redemption.status }.from("pending").to("cancelled")
      end

      it "returns points to user" do
        original_balance = user.points_balance
        redemption
        expect { redemption.cancel! }.to change { user.reload.points_balance }.by(100)
      end

      it "returns true" do
        expect(redemption.cancel!).to be true
      end
    end

    context "with non-pending status" do
      let(:reward) { create(:reward, points_cost: 100) }
      let(:user) { create(:user, points_balance: 150) }
      let!(:redemption) do
        redemption = create(:redemption, user: user, reward: reward)
        redemption.update_column(:status, "completed")
        user.reload
        redemption
      end

      it "doesn't change status" do
        expect { redemption.cancel! }.not_to change { redemption.reload.status }
      end

      it "doesn't return points" do
        original_balance = user.points_balance
        redemption.cancel!
        expect(user.reload.points_balance).to eq(original_balance)
      end

      it "returns false and adds error" do
        expect(redemption.cancel!).to be false
        expect(redemption.errors[:base]).to include("Only pending redemptions can be cancelled")
      end
    end
  end
end
