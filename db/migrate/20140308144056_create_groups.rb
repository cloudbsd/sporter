class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :uniqname
      t.string :name
      t.text :aboutme

      t.timestamps
    end
  end
end
