# frozen_string_literal: true

require 'rails_helper'

ROUTES = {
  signup: {
    path: '/api/v1/auth',
    method: :post
  }.freeze,
  sign_in: {
    path: '/api/v1/auth/sign_in',
    method: :post
  }.freeze,
  delete: {
    path: '/api/v1/auth',
    method: :delete
  }.freeze
}.freeze

EMAIL = 'user@example.com'
PASSWORD = 'password123'
NICKNAME = 'test_player'

RSpec.describe 'Auth API', type: :request do
  let(:json_headers) do
    {
      'Accept' => 'application/json',
      'Content-Type' => 'application/json'
    }
  end

  describe "[Signup] #{ROUTES[:signup][:method]} #{ROUTES[:signup][:path]}" do
    it 'creates an account and returns 201' do
      params = { email: EMAIL, password: PASSWORD, nickname: NICKNAME }.to_json

      expect do
        send(ROUTES[:signup][:method], ROUTES[:signup][:path], params: params, headers: json_headers)
      end.to change(User, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(response.parsed_body['user']).to include('email' => EMAIL, 'id' => User.last.id, 'nickname' => NICKNAME)
    end

    it 'creates an account with nested user params and returns 201' do
      params = { user: { email: EMAIL, password: PASSWORD, nickname: NICKNAME } }.to_json

      send(ROUTES[:signup][:method], ROUTES[:signup][:path], params: params, headers: json_headers)

      expect(response).to have_http_status(:created)
      expect(response.parsed_body['user']).to include('email' => EMAIL, 'nickname' => NICKNAME)
    end

    it 'returns 422 with invalid params' do
      params = { email: EMAIL, password: '123' }.to_json

      send(ROUTES[:signup][:method], ROUTES[:signup][:path], params: params, headers: json_headers)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.parsed_body['errors']).to be_an(Array)
    end
  end

  describe "[Login] #{ROUTES[:sign_in][:method]} #{ROUTES[:sign_in][:path]}" do
    let!(:user) { create(:user, email: EMAIL, password: PASSWORD, password_confirmation: PASSWORD) }

    it 'returns 200 and a JWT in Authorization' do
      params = { email: user.email, password: PASSWORD }

      send(ROUTES[:sign_in][:method], ROUTES[:sign_in][:path], params: params.to_json, headers: json_headers)

      expect(response).to have_http_status(:ok)
      expect(response.headers['Authorization']).to be_present
      expect(response.parsed_body['user']).to include('email' => user.email)
    end

    it 'returns 401 if credentials are invalid' do
      params = { email: user.email, password: '************' }.to_json
      send(ROUTES[:sign_in][:method], ROUTES[:sign_in][:path], params: params, headers: json_headers)
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "[Delete Account] #{ROUTES[:delete][:method]} #{ROUTES[:delete][:path]}" do
    let!(:user) { create(:user, email: EMAIL, password: PASSWORD, password_confirmation: PASSWORD) }

    it 'deletes the account and returns 204' do
      token = login_and_get_token(email: user.email, password: PASSWORD)
      send(ROUTES[:delete][:method], ROUTES[:delete][:path], headers: json_headers.merge('Authorization' => token))

      expect(response).to have_http_status(:no_content)
      expect(User.find_by(id: user.id)).to be_nil
    end

    it 'returns 401 if not authenticated' do
      send(ROUTES[:delete][:method], ROUTES[:delete][:path], headers: json_headers)
      expect(response).to have_http_status(:unauthorized)
    end

    it 'returns 422 if the deletion fails' do
      token = login_and_get_token(email: user.email, password: PASSWORD)
      allow_any_instance_of(User).to receive(:destroy).and_return(false)

      send(ROUTES[:delete][:method], ROUTES[:delete][:path], headers: json_headers.merge('Authorization' => token))

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end
