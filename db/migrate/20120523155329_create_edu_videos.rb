class CreateEduVideos < ActiveRecord::Migration
  def change
    create_table :edu_videos do |t|
      t.string :subject
      t.string :topic
      t.string :subtopic
      t.string :description
      t.string :url

      t.timestamps
    end
  end
end
