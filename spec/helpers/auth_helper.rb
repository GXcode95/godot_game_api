# frozen_string_literal: true

module AuthHelper
  def login_and_get_token(email:, password:)
    post '/api/v1/auth/sign_in', params: { email: email, password: password }.to_json, headers: json_headers
    expect(response).to have_http_status(:ok)
    response.headers['Authorization']
  end
end
