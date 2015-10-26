# Getting errors for some Aleph records so had to remove the GIN index,
# and make it a GIST. Field is indexed to speed up lookup performance. Errors were:
# PG::Error: ERROR:  index row size xxx exceeds maximum xxx for index "properties"
# GIST should be sufficient for our purposes
# See: http://www.postgresql.org/docs/9.1/static/textsearch-indexes.html
class ChangeIdentitiesPropertiesIndexFromGinToGist < ActiveRecord::Migration
  def up
    remove_index :identities, :properties
    add_index :identities, :properties, using: :gist
  end
  def down
    remove_index :identities, :properties
    add_index :identities, :properties, using: :gin
  end
end
