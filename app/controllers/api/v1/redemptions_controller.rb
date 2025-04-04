module Api
  module V1
    class RedemptionsController < BaseController
      def create
        @user = User.find(params[:redemption][:user_id])
        @redemption = @user.redemptions.build(redemption_params)

        if @redemption.save
          render json: @redemption, status: :created
        else
          render json: { errors: @redemption.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show
        @redemption = Redemption.find(params[:id])
        render json: @redemption
      end

      def cancel
        @redemption = Redemption.find(params[:id])

        if @redemption.cancel!
          render json: @redemption
        else
          render json: { errors: @redemption.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def redemption_params
        params.require(:redemption).permit(:reward_id)
      end
    end
  end
end
