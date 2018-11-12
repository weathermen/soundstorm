class CreateTracks < ActiveRecord::Migration[5.2]
  def change
    create_table :tracks do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.integer :duration

      t.timestamps
    end
  end
end
