class RemoveCombinedMeetingsJoinTable < ActiveRecord::Migration
  
  class CombinedMeetingsMeeting < ActiveRecord::Base
    belongs_to :combined_meeting
    belongs_to :meeting
  end
  
  def self.up
    CombinedMeetingsMeeting.all.each do |cmm|
      cmm.meeting.node.update_attributes :parent => cmm.combined_meeting.node
    end
    drop_table :combined_meetings_meetings
  end

  def self.down
    create_table :combined_meetings_meetings do |t|
      t.integer :combined_meeting_id, :null => false, :references => :events
      t.integer :meeting_id, :null => false, :references => :events
    
      t.integer :position, :null => false
    
      t.timestamps
    end
    
        add_index :combined_meetings_meetings, [ :combined_meeting_id, :meeting_id ], :unique => true, :name => 'index_on_combined_meeting_id_and_meeting_id'
    
    CombinedMeetingsMeeting.reset_column_information
    
    CombinedMeeting.all.each do |cm|
      cm.node.children.each do |m|
        CombinedMeetingsMeeting.create(:combined_meeting => cm, :meeting => m.content)
        m.update_attributes :parent => cm.node.parent
      end
    end
  end
end
