class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.references :user, index: true
      t.references :activity, index: true
      t.integer :friend_number
      t.decimal :derated_pay
      t.decimal :net_pay
      t.integer :card_id, index: true

      t.timestamps
    end
  end
end
