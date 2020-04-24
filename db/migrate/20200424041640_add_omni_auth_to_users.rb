class AddOmniAuthToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :name, :string
    add_column :users, :remember_token, :string
    add_index :users, [:uid, :provider], unique: true

  end
end
