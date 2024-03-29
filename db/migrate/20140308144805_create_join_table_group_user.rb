class CreateJoinTableGroupUser < ActiveRecord::Migration
  def change
    create_join_table :groups, :users do |t|
      t.index :group_id
      t.index :user_id
      t.index [:group_id, :user_id], unique: true
      # t.index [:user_id, :group_id]
    end
  end
end
