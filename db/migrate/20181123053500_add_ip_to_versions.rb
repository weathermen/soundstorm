class AddIpToVersions < ActiveRecord::Migration[5.2]
  def change
    add_column :versions, :ip, :inet
  end
end
