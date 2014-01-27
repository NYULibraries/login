class AddInstitutionCodeToUser < ActiveRecord::Migration
  def change
    add_column :users, :institution_code, :string, null: false, default: ""
  end
end
