class CreateFeeItems < ActiveRecord::Migration
  def change
    create_table :fee_items do |t|
      t.references :activity, index: true
      t.references :fee, index: true
      t.decimal :price

      t.timestamps
    end
  end
end
