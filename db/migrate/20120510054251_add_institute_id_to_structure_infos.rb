class AddInstituteIdToStructureInfos < ActiveRecord::Migration
  def change
    add_column :structure_infos, :institute_id, :integer

  end
end
