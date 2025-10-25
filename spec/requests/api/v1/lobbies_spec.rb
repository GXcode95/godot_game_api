# frozen_string_literal: true

require 'rails_helper'

ROUTE_LOBBIES = {
  index: { method: :get, path: '/api/v1/lobbies' }.freeze,
  show: { method: :get, path: ->(id) { "/api/v1/lobbies/#{id}" } }.freeze,
  create: { method: :post,   path: '/api/v1/lobbies' }.freeze,
  update: { method: :patch,  path: ->(id) { "/api/v1/lobbies/#{id}" } }.freeze,
  destroy: { method: :delete, path: ->(id) { "/api/v1/lobbies/#{id}" } }.freeze
}.freeze

RSpec.describe 'Lobbies API', type: :request do
  let(:json_headers) do
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  end

  let!(:host)  { create(:user) }
  let!(:guest) { create(:user) }
  let!(:token) { login_and_get_token(email: host.email, password: 'password123') }

  describe "[Index] #{ROUTE_LOBBIES[:index][:method].upcase} #{ROUTE_LOBBIES[:index][:path]}" do
    it 'lists the lobbies and returns 200' do
      create(:lobby, host: host)
      create(:lobby)
      create(:lobby, :started)

      send(
        ROUTE_LOBBIES[:index][:method],
        ROUTE_LOBBIES[:index][:path],
        headers: json_headers.merge('Authorization' => token)
      )

      expect(response).to have_http_status(:ok)
      body = response.parsed_body
      expect(body['lobbies']).to be_an(Array)
      expect(body['lobbies'].size).to eq(2)
      expect(body['lobbies'].pluck('status').uniq).to eq(['pending'])
      expect(body['lobbies'].first).to include(
        'host' => { 'id' => host.id, 'email' => host.email, 'nickname' => host.nickname }
      )
    end
  end

  describe "[Create] #{ROUTE_LOBBIES[:create][:method].upcase} #{ROUTE_LOBBIES[:create][:path]}" do
    it 'creates a lobby and returns 201' do
      params = { lobby: { host_id: host.id } }.to_json

      expect do
        send(
          ROUTE_LOBBIES[:create][:method],
          ROUTE_LOBBIES[:create][:path],
          params: params,
          headers: json_headers.merge('Authorization' => token)
        )
      end.to change(Lobby, :count).by(1)

      expect(response).to have_http_status(:created)
      body = response.parsed_body
      expect(body['lobby']).to include(
        'id' => Lobby.last.id,
        'status' => 'pending',
        'host' => { 'id' => host.id, 'email' => host.email, 'nickname' => host.nickname },
        'guest' => nil
      )
    end

    it 'returns 422 if the parameters are invalid' do
      params = { lobby: { guest_id: guest.id } }.to_json

      expect do
        send(
          ROUTE_LOBBIES[:create][:method],
          ROUTE_LOBBIES[:create][:path],
          params: params,
          headers: json_headers.merge('Authorization' => token)
        )
      end.not_to change(Lobby, :count)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body['errors']).to be_an(Array)
      expect(response.parsed_body['errors']).not_to be_empty
    end
  end

  describe "[Show] #{ROUTE_LOBBIES[:show][:method].upcase} #{ROUTE_LOBBIES[:show][:path]}" do
    it 'returns the lobby and returns 200' do
      lobby = create(:lobby, :started, host: host, guest: guest)

      send(
        ROUTE_LOBBIES[:show][:method],
        ROUTE_LOBBIES[:show][:path].call(lobby.id),
        headers: json_headers.merge('Authorization' => token)
      )

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['lobby']).to include(
        'status' => 'started',
        'guest' => { 'id' => guest.id, 'email' => guest.email, 'nickname' => guest.nickname },
        'host' => { 'id' => host.id, 'email' => host.email, 'nickname' => host.nickname },
        'id' => lobby.id
      )
    end
  end

  describe "[Update] #{ROUTE_LOBBIES[:update][:method].upcase} #{ROUTE_LOBBIES[:update][:path]}" do
    it 'updates the status and returns 200' do
      lobby = create(:lobby, host: host)
      params = { lobby: { guest_id: guest.id } }.to_json

      send(
        ROUTE_LOBBIES[:update][:method],
        ROUTE_LOBBIES[:update][:path].call(lobby.id),
        params: params,
        headers: json_headers.merge('Authorization' => token)
      )

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['lobby']).to include(
        'status' => 'started',
        'guest' => { 'id' => guest.id, 'email' => guest.email, 'nickname' => guest.nickname },
        'host' => { 'id' => host.id, 'email' => host.email, 'nickname' => host.nickname },
        'id' => lobby.id
      )
    end

    it 'returns 422 if the update is invalid' do
      lobby = create(:lobby, :started)
      params = { lobby: { host_id: nil } }.to_json

      send(
        ROUTE_LOBBIES[:update][:method],
        ROUTE_LOBBIES[:update][:path].call(lobby.id),
        params: params,
        headers: json_headers.merge('Authorization' => token)
      )

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body['errors']).to be_an(Array)
      expect(response.parsed_body['errors']).not_to be_empty
    end
  end

  describe "[Destroy] #{ROUTE_LOBBIES[:destroy][:method].upcase} #{ROUTE_LOBBIES[:destroy][:path]}" do
    it 'deletes the lobby and returns 204' do
      lobby = create(:lobby, :started)

      expect do
        send(
          ROUTE_LOBBIES[:destroy][:method],
          ROUTE_LOBBIES[:destroy][:path].call(lobby.id),
          headers: json_headers.merge('Authorization' => token)
        )
      end.to change(Lobby, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
