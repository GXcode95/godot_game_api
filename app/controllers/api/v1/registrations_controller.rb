# frozen_string_literal: true

module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json

      before_action :ensure_user_params_for_signup, only: [:create] # rubocop:disable Rails/LexicallyScopedActionFilter
      before_action :authenticate_api_v1_user!, only: [:destroy]

      def destroy
        user = current_api_v1_user
        return head :unauthorized unless user

        if user.destroy
          head :no_content
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def ensure_user_params_for_signup
        return if params[:user].present?

        params[:user] = params.permit(:email, :password, :nickname)
      end

      def sign_up_params
        params.require(:user).permit(:email, :password, :nickname)
      end

      def respond_with(resource, _opts = {})
        if resource.persisted?
          render json: { user: resource.as_json(only: %i[id email nickname]), status: 'created' }, status: :created
        else
          render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def sign_up(resource_name, resource)
        sign_in(resource_name, resource, store: false)
      end
    end
  end
end
