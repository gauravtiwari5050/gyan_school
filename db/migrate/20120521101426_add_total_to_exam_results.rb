class AddTotalToExamResults < ActiveRecord::Migration
  def change
    add_column :exam_results, :total, :integer

  end
end
