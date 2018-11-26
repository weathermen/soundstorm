# frozen_string_literal: true

class AddCountsToTracks < ActiveRecord::Migration[5.2]
  def change
    add_column :tracks, :comments_count, :integer, index: true
    add_column :tracks, :likes_count, :integer, index: true
    add_column :tracks, :listens_count, :integer, index: true
  end
end
