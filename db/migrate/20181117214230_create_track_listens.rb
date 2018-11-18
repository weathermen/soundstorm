class CreateTrackListens < ActiveRecord::Migration[5.2]
  def change
    create_table :track_listens do |t|
      t.inet :ip_address
      t.references :user, foreign_key: true
      t.references :track, foreign_key: true

      t.timestamps
    end
  end
end
