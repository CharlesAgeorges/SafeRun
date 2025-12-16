class AddPublicToRuns < ActiveRecord::Migration[7.2]
  def change
    add_column :runs, :public, :boolean, default: false
  end
end
