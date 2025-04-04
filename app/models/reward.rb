class Reward < ApplicationRecord
  has_many :redemptions, dependent: :destroy

  validates :name, presence: true
  validates :points_cost, presence: true, numericality: { greater_than: 0 }

  scope :active, -> { where(is_active: true) }
  scope :inactive, -> { where(is_active: false) }

  def available?
    is_active
  end

  def can_be_redeemed_by?(user)
    available? && user.has_sufficient_points?(points_cost)
  end
end
