# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LobbyChannel, type: :channel do
  let(:lobby) { create(:lobby) }

  describe '#subscribed' do
    it 'streams for the given lobby id' do
      subscribe(id: lobby.id)
      expect(subscription).to be_confirmed
      expect(subscription).to have_stream_for(lobby)
    end
  end

  describe 'broadcasting' do
    it 'receives broadcast on stream_for' do
      subscribe(id: lobby.id)
      expect(subscription).to be_confirmed

      expect do
        LobbyChannel.broadcast_to(lobby, { event: :updated, lobby: { id: lobby.id } })
      end.to have_broadcasted_to(lobby).from_channel(LobbyChannel)
    end
  end
end
