class User < ApplicationRecord
  has_many :redemptions, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :points_balance, numericality: { greater_than_or_equal_to: 0 }

  def add_points(amount)
    with_lock do
      update!(points_balance: points_balance + amount)
    end
  end

  def deduct_points(amount)
    with_lock do
      raise InsufficientPointsError unless has_sufficient_points?(amount)
      update!(points_balance: points_balance - amount)
    end
  end

  def has_sufficient_points?(amount)
    points_balance >= amount
  end

  def active_redemptions
    redemptions.where(status: "pending")
  end

  def completed_redemptions
    redemptions.where(status: "completed")
  end

  class InsufficientPointsError < StandardError; end
end
