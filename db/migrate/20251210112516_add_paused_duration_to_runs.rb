class AddPausedDurationToRuns < ActiveRecord::Migration[7.2]
  def change
    add_column :runs, :paused_duration, :integer, default: 0
    add_column :runs, :paused_at, :datetime
  end
end
