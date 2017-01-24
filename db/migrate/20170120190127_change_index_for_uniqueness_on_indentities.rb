class ChangeIndexForUniquenessOnIndentities < ActiveRecord::Migration
  def up
    remove_index :identities, [:uid, :provider]
    add_index :identities, [:user_id, :uid, :provider], unique: true
  end
  def down
    remove_index :identities, [:user_id, :uid, :provider]
    add_index :identities, [:uid, :provider], unique: true
  end
end
