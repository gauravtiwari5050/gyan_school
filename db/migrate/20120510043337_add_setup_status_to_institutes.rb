class AddSetupStatusToInstitutes < ActiveRecord::Migration
  def change
    add_column :institutes, :setup_status, :string

  end
end
