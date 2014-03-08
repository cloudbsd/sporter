class AddProfileToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_column :users, :name, :string
    add_column :users, :birthday, :date
    add_column :users, :gender, :string
    add_column :users, :mobile, :string
    add_column :users, :telephone, :string
    add_column :users, :gravatar, :string
    add_column :users, :province, :string
    add_column :users, :city, :string
    add_column :users, :district, :string
    add_column :users, :location, :string
    add_column :users, :aboutme, :text
  end
end
