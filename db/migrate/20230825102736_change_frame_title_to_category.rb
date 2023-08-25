class ChangeFrameTitleToCategory < ActiveRecord::Migration[7.0]
  def change
    rename_column :frames, :title, :category
  end
end
