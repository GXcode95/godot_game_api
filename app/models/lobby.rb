# frozen_string_literal: true

# == Schema Information
#
# Table name: lobbies
#
#  id         :bigint           not null, primary key
#  status     :integer          default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  guest_id   :bigint
#  host_id    :bigint           not null
#
# Indexes
#
#  index_lobbies_on_guest_id  (guest_id) UNIQUE
#  index_lobbies_on_host_id   (host_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (guest_id => users.id)
#  fk_rails_...  (host_id => users.id)
#
class Lobby < ApplicationRecord
  belongs_to :host, class_name: 'User', inverse_of: :hosted_lobby
  belongs_to :guest, class_name: 'User', optional: true, inverse_of: :guest_lobby

  validates :host_id, uniqueness: true
  validates :guest_id, uniqueness: true, allow_nil: true

  enum :status, {
    pending: 0,
    started: 1,
    finished: 2
  }

  before_update :set_status_to_started, if: :will_save_change_to_guest_id?

  after_update_commit :broadcast_update

  private

  def set_status_to_started
    self.status = :started
  end

  def broadcast_update
    ::LobbyChannel.broadcast_to(
      self,
      {
        event: :updated,
        lobby: LobbyBlueprint.render(self)
      }
    )
  end
end
