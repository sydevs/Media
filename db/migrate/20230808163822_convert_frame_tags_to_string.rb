class ConvertFrameTagsToString < ActiveRecord::Migration[7.0]
  def up
    change_column :frames, :tags, :string, array: false, default: ""
  end
  def down
    change_column :frames, :tags, :string, array: true, default: []
  end
end
