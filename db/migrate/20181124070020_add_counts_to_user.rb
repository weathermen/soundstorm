# frozen_string_literal: true

class AddCountsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :followers, :integer, default: 0
    add_column :users, :followees, :integer, default: 0
    add_column :users, :tracks_count, :integer, default: 0
    add_column :tracks, :likers, :integer, default: 0
  end
end
