# frozen_string_literal: true

class AllowNullGuestInLobbies < ActiveRecord::Migration[7.2]
  def up
    change_column_null :lobbies, :guest_id, true
  end

  def down
    change_column_null :lobbies, :guest_id, false
  end
end
