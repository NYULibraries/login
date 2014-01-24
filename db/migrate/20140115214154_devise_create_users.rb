class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|

      ## Database authenticatable
      t.string :username, null: false, default: ""
      t.string :email,    null: false, default: ""

      ## Trackable
      t.integer :sign_in_count, default: 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      ## Token authenticatable
      # t.string :authentication_token

      t.boolean :admin, default: false

      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
    # add_index :users, :authentication_token, unique: true
  end
end
