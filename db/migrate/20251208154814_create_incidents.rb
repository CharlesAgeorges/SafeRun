class CreateIncidents < ActiveRecord::Migration[7.2]
  def change
    create_table :incidents do |t|
      t.string :incident_detail
      t.references :run, null: false, foreign_key: true

      t.timestamps
    end
  end
end
