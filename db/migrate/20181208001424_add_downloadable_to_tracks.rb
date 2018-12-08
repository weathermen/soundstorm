class AddDownloadableToTracks < ActiveRecord::Migration[5.2]
  def change
    add_column :tracks, :downloadable, :boolean, default: false, null: false
  end
end
