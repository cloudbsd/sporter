class CreateCardTypes < ActiveRecord::Migration
  def change
    create_table :card_types do |t|
      t.references :group, index: true
      t.string :kind
      t.string :name
      t.decimal :price
      t.integer :duration
      t.integer :number

      t.timestamps
    end
  end
end
