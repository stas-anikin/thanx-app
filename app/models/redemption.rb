class Redemption < ApplicationRecord
  belongs_to :user
  belongs_to :reward

  validates :points_spent, numericality: { greater_than: 0 }, allow_nil: true
  validates :status, inclusion: { in: %w[pending completed cancelled] }
  validate :user_has_sufficient_points, on: :create
  validate :reward_is_active, on: :create

  before_validation :set_points_spent, on: :create
  after_create :deduct_points_from_user

  def complete!
    update!(status: "completed")
  end

  def cancel!
    with_lock do
      if status == "pending"
        user.add_points(points_spent)
        update!(status: "cancelled")
        true
      else
        errors.add(:base, "Only pending redemptions can be cancelled")
        false
      end
    end
  end

  private

  def set_points_spent
    self.points_spent ||= reward&.points_cost
  end

  def deduct_points_from_user
    user.deduct_points(points_spent)
  end

  def user_has_sufficient_points
    return unless user && reward
    unless user.has_sufficient_points?(points_spent || reward.points_cost)
      errors.add(:base, "Insufficient points")
    end
  end

  def reward_is_active
    return unless reward
    unless reward.available?
      errors.add(:reward, "is not available")
    end
  end
end
