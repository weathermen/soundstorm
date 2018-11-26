# frozen_string_literal: true

class AddActivityToVersions < ActiveRecord::Migration[5.2]
  def change
    add_column :versions, :activity, :jsonb
  end
end
