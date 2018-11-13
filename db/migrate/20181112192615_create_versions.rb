# This migration creates the `versions` table, the only schema PT requires.
# All other migrations PT provides are optional.
class CreateVersions < ActiveRecord::Migration[5.2]
  def change
    create_table :versions do |t|
      t.references :item, polymorphic: true, index: true
      t.string   :event,     null: false
      t.string   :whodunnit
      t.jsonb    :object
      t.boolean  :remote, default: false, null: false, index: true
      t.timestamps
    end
  end
end
