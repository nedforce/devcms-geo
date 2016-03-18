class CreateCombinedMeetingsMeetings < ActiveRecord::Migration
  def up
    create_table :combined_meetings_meetings do |t|
      t.integer :combined_meeting_id, :null => false, :references => :events
      t.integer :meeting_id, :null => false, :references => :events

      t.integer :position, :null => false

      t.timestamps
    end

    add_index :combined_meetings_meetings, [ :combined_meeting_id, :meeting_id ], :unique => true, :name => 'index_on_combined_meeting_id_and_meeting_id'
  end

  def down
    drop_table :combined_meetings_meetings
  end
end
