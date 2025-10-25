# frozen_string_literal: true

module Api
  module V1
    class SessionsController < Devise::SessionsController
      respond_to :json

      before_action :ensure_user_params_for_signin, only: [:create]

      def create
        user_params = params.require(:user).permit(:email, :password)
        user = User.find_for_database_authentication(email: user_params[:email])

        if user&.valid_password?(user_params[:password])
          sign_in(:api_v1_user, user, store: false)

          token = request.env['warden-jwt_auth.token']
          response.set_header('Authorization', "Bearer #{token}") if token.present?
          render json: { user: user.as_json(only: %i[id email nickname]) }, status: :ok
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      private

      def ensure_user_params_for_signin
        return if params[:user].present?

        params[:user] = params.permit(:email, :password)
      end
    end
  end
end
