class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      t.string :name
      t.integer :code, index: true
      t.integer :city_code, index: true

      t.timestamps
    end
  end
end
