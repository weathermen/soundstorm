class AddBroadcastedAtToVersions < ActiveRecord::Migration[5.2]
  def change
    add_column :versions, :broadcasted_at, :datetime
  end
end
