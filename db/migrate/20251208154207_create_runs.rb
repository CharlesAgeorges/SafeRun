class CreateRuns < ActiveRecord::Migration[7.2]
  def change
    create_table :runs do |t|
      t.integer :duration
      t.float :distance
      t.string :status
      t.string :start_point
      t.float :start_point_lat
      t.float :start_point_lng
      t.datetime :started_at
      t.datetime :ended_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
