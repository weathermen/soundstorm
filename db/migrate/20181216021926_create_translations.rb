# frozen_string_literal: true

class CreateTranslations < ActiveRecord::Migration[5.2]
  def change
    create_table :translations do |t|
      t.string :locale, default: I18n.default_locale.to_s, null: false
      t.string :key, null: false, index: true
      t.text :value, null: false
      t.text :interpolations
      t.boolean :is_proc, default: false, null: false
      t.timestamps null: false
    end
  end
end
