# frozen_string_literal: true

class CreateLobbies < ActiveRecord::Migration[7.2]
  def change
    create_table :lobbies do |t|
      t.references :host, null: false, foreign_key: { to_table: :users }
      t.references :guest, null: false, foreign_key: { to_table: :users }
      t.integer :status, null: false, default: 0

      t.timestamps null: false
    end
  end
end
