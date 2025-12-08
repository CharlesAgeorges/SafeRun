class CreateRunBadges < ActiveRecord::Migration[7.2]
  def change
    create_table :run_badges do |t|
      t.references :run, null: false, foreign_key: true
      t.references :badge, null: false, foreign_key: true

      t.timestamps
    end
  end
end
