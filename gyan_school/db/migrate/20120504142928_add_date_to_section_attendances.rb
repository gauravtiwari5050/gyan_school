class AddDateToSectionAttendances < ActiveRecord::Migration
  def change
    add_column :section_attendances, :date, :date

  end
end
