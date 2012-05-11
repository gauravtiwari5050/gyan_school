class RemoveSetupStatusFromInstitutes < ActiveRecord::Migration
  def up
    remove_column :institutes, :setup_status
      end

  def down
    add_column :institutes, :setup_status, :string
  end
end
