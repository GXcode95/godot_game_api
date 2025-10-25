# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { described_class.new(current_user) }

  let(:host) { create(:user) }
  let(:guest) { create(:user) }
  let(:other) { create(:user) }
  let(:lobby) { create(:lobby, host: host, guest: guest) }

  context 'when user is nil' do
    let(:current_user) { nil }

    it 'cannot do anything on Lobby' do
      expect(ability.can?(:manage, lobby)).to be false
      expect(ability.can?(:update, lobby)).to be false
      expect(ability.can?(:destroy, lobby)).to be false
    end
  end

  context 'when user is host' do
    let(:current_user) { host }

    it 'can manage the Lobby where he is host' do
      expect(ability.can?(:manage, lobby)).to be true
      expect(ability.can?(:update, lobby)).to be true
      expect(ability.can?(:destroy, lobby)).to be true
    end

    it 'cannot manage another Lobby' do
      other_lobby = create(:lobby)
      expect(ability.can?(:manage, other_lobby)).to be false
    end
  end

  context 'when user is guest' do
    let(:current_user) { guest }

    it 'can update/destroy the Lobby where he is guest' do
      expect(ability.can?(:update, lobby)).to be true
      expect(ability.can?(:destroy, lobby)).to be true
      expect(ability.can?(:manage, lobby)).to be false
    end

    it 'cannot update/destroy another Lobby' do
      other_lobby = create(:lobby)
      expect(ability.can?(:update, other_lobby)).to be false
      expect(ability.can?(:destroy, other_lobby)).to be false
    end
  end

  context 'when user is neither host nor guest' do
    let(:current_user) { other }

    it 'cannot destroy or update the Lobby' do
      expect(ability.can?(:update, lobby)).to be false
      expect(ability.can?(:destroy, lobby)).to be false
      expect(ability.can?(:manage, lobby)).to be false
    end
  end
end
