class AddPresentToSectionAttendances < ActiveRecord::Migration
  def change
    add_column :section_attendances, :present, :boolean

  end
end
