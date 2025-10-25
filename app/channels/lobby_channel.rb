# frozen_string_literal: true

class LobbyChannel < ApplicationCable::Channel
  def subscribed
    lobby = Lobby.find(params[:id])
    stream_for lobby
  end

  def unsubscribed; end
end
