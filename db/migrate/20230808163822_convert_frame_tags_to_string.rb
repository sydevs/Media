class ConvertFrameTagsToString < ActiveRecord::Migration[7.0]
  def up
    change_column :frames, :tags, array: false, default: ""
  end
  def down
    change_column :frames, :tags, array: true, default: []
  end
end
