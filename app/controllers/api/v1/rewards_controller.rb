module Api
  module V1
    class RewardsController < BaseController
      def index
        @rewards = Reward.active
        render json: @rewards
      end

      def show
        @reward = Reward.find(params[:id])
        render json: @reward
      end
    end
  end
end
