# frozen_string_literal: true

class AddUniqueIndexesToLobbies < ActiveRecord::Migration[7.2]
  def up
    remove_index :lobbies, :host_id if index_exists?(:lobbies, :host_id)
    add_index :lobbies, :host_id, unique: true

    remove_index :lobbies, :guest_id if index_exists?(:lobbies, :guest_id)
    add_index :lobbies, :guest_id, unique: true
  end

  def down
    remove_index :lobbies, :host_id if index_exists?(:lobbies, :host_id)
    add_index :lobbies, :host_id

    remove_index :lobbies, :guest_id if index_exists?(:lobbies, :guest_id)
    add_index :lobbies, :guest_id
  end
end


