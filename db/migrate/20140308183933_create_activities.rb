class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.datetime :started_at
      t.datetime :stopped_at

      t.timestamps
    end
  end
end
