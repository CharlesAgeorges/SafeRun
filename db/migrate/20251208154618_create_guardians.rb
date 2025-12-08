class CreateGuardians < ActiveRecord::Migration[7.2]
  def change
    create_table :guardians do |t|
      t.string :name
      t.string :phone_number
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
