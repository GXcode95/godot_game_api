# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#lobby' do
    it 'returns the hosted lobby when the user is host' do
      user = create(:user)
      lobby = create(:lobby, host: user)

      expect(user.lobby).to eq(lobby)
    end

    it 'returns the joined lobby when the user is guest' do
      user = create(:user)
      lobby = create(:lobby, guest: user)

      expect(user.lobby).to eq(lobby)
    end

    it 'returns nil if no lobby' do
      user = create(:user)

      expect(user.lobby).to be_nil
    end
  end
end
