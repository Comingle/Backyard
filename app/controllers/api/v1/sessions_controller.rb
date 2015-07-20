module Api
  module V1
    class SessionsController < V1Controller
      skip_before_filter :authenticate, only: :create

      def create
        identifier = session_params[:identifier]
        if @user = User.where("email = ? or username = ?", identifier, identifier).first
          if @user.valid_password?(session_params[:password])
            token = @user.generate_authentication_token
            render json: { authentication_token: token, identifier: identifier }
          else
            render json: { errors: "Could not find a user with those credentials." }, status: :not_found
          end
        else
          render json: { errors: "Could not find a user with those credentials." }, status: :not_found
        end
      end

      def destroy
        @user = current_user.delete :hashed_authentication_token
      end

      private

      def session_params
        params.require(:session).permit(:password, :identifier)
      end
    end
  end
end
