# frozen_string_literal: true

class CreateReleasedTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :released_tracks do |t|
      t.references :track, foreign_key: true
      t.references :release, foreign_key: true
      t.integer :number, null: false, index: true

      t.timestamps
    end
  end
end
