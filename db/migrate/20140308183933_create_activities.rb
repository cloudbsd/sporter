class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :group, index: true
      t.string :title
      t.datetime :started_at
      t.datetime :stopped_at
      t.datetime :applied_at
      t.integer :number_limit
      t.string :pay_type
      t.string :province
      t.string :city
      t.string :district
      t.string :location
      t.string :approval
      t.string :condition

      t.timestamps
    end
  end
end
