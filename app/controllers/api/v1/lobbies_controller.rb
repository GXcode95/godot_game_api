# frozen_string_literal: true

module Api
  module V1
    class LobbiesController < AuthenticatedController
      before_action :set_lobby, only: [:show, :update, :destroy]

      def index
        @lobbies = Lobby.where(status: :pending)
        render json: { lobbies: LobbyBlueprint.render_as_hash(@lobbies) },
               status: :ok
      end

      def show
        render json: { lobby: LobbyBlueprint.render_as_hash(@lobby) },
               status: :ok
      end

      def create
        @lobby = Lobby.new(lobby_params)
        if @lobby.save
          render json: { lobby: LobbyBlueprint.render_as_hash(@lobby) },
                 status: :created
        else
          render json: { errors: @lobby.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def update
        if @lobby.update(lobby_params)
          render json: { lobby: LobbyBlueprint.render_as_hash(@lobby) },
                 status: :ok
        else
          render json: { errors: @lobby.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def destroy
        @lobby.destroy
        head :no_content
      end

      private

      def lobby_params
        params.require(:lobby).permit(:host_id, :guest_id, :status)
      end

      def set_lobby
        @lobby = Lobby.find(params[:id])
      end
    end
  end
end
