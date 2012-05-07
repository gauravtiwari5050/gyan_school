class RenameSessions < ActiveRecord::Migration
  def up
    rename_table :sessions,:institute_sessions
  end

  def down
    rename_table :institute_sessions,:sessions
  end
end
