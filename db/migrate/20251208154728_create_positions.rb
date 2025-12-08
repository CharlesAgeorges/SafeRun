class CreatePositions < ActiveRecord::Migration[7.2]
  def change
    create_table :positions do |t|
      t.float :latitude
      t.float :longitude
      t.float :distance_from_last
      t.references :run, null: false, foreign_key: true

      t.timestamps
    end
  end
end
