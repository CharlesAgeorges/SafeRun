class CreateGuardianNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :guardian_notifications do |t|
      t.references :run, null: false, foreign_key: true
      t.references :guardian, null: false, foreign_key: true
      t.float :longitude
      t.float :latitude
      t.string :status

      t.timestamps
    end
  end
end
