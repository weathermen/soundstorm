# frozen_string_literal: true

class CreateReleases < ActiveRecord::Migration[5.2]
  def change
    create_table :releases do |t|
      t.string :name
      t.references :user, foreign_key: true
      t.string :description
      t.citext :slug, null: false, unique: true

      t.timestamps
    end
  end
end
