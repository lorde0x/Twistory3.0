class AddFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, unique: true
    add_column :users, :image, :string, default: ""
    add_column :users, :permissions, :integer, default: 100
  end
end
