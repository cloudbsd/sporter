class CreateFees < ActiveRecord::Migration
  def change
    create_table :fees do |t|
      t.string :name
      t.references :user, index: true
      t.references :group, index: true

      t.timestamps
    end
  end
end
