class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :uniqname
      t.string :name
      t.string :pay_type
      t.text :aboutme

      t.timestamps
    end
  end
end
