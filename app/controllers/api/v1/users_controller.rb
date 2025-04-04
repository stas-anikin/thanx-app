module Api
  module V1
    class UsersController < BaseController
      before_action :set_user, only: [ :show, :points_balance, :redemptions, :add_points ]

      def index
        @users = User.all
        render json: @users
      end

      def show
        render json: @user
      end

      def create
        @user = User.new(user_params)
        if @user.save
          render json: @user, status: :created
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def points_balance
        render json: { points_balance: @user.points_balance }
      end

      def redemptions
        render json: @user.redemptions
      end

      def add_points
        amount = params[:amount].to_i
        @user.add_points(amount)
        render json: { points_balance: @user.points_balance }
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.require(:user).permit(:email)
      end
    end
  end
end
