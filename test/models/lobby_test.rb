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
require 'test_helper'

class LobbyTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
