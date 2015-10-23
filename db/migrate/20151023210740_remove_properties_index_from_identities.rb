# Getting errors for some Aleph records so had to remove the index,
# not sure why we originally indexed:
# PG::Error: ERROR:  index row size xxx exceeds maximum xxx for index "properties"
class RemovePropertiesIndexFromIdentities < ActiveRecord::Migration
  def up
    remove_index :identities, :properties
  end
  def down
    add_index :identities, :properties, using: :gin
  end
end
