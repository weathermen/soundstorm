class AddActivityToVersions < ActiveRecord::Migration[5.2]
  def change
    add_column :versions, :activity, :jsonb
  end
end
