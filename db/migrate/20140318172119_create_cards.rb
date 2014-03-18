class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.references :user, index: true
      t.references :card_type, index: true
      t.date :started_at
      t.date :stopped_at
      t.integer :number

      t.timestamps
    end
  end
end
