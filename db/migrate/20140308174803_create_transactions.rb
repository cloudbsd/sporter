class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.references :user, index: true
      t.string :action
      t.decimal :amount

      t.timestamps
    end
  end
end
