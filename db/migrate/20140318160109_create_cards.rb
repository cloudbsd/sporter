class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :name
      t.references :user, index: true
      t.references :group, index: true
      t.decimal :price
      t.string :duration
      t.date :started_at
      t.date :stopped_at
      t.integer :number

      t.timestamps
    end
  end
end
