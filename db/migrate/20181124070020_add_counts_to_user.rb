# frozen_string_literal: true

class AddCountsToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :followers_count,  :integer, index: true, default: 0
    add_column :users, :followees_count,  :integer, index: true, default: 0
    add_column :users, :tracks_count,     :integer, index: true, default: 0
    add_column :users, :likees_count,     :integer, index: true, default: 0
  end
end
