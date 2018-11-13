class CreateTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :tracks do |t|
      t.references :user, foreign_key: true
      t.string :name, null: false
      t.citext :slug, null: false, index: true
      t.integer :duration

      t.timestamps
    end
  end
end
