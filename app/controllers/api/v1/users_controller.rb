module Api
  module V1
    class UsersController < V1Controller
      skip_before_filter :authenticate, only: :create
      def create
        @user = User.create!(user_params)
        render json: @user
      end

      def show
        render json: current_user, serializer: UserSerializer
      end

      private

      def user_params
        secure_params = [:username, :email, :password, :password_confirmation, :address, :avatar]
        params.require(:user).permit(secure_params)
      end
    end
  end
end
