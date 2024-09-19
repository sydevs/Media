class AddStoryblokIds < ActiveRecord::Migration[7.0]
  def change
    add_column :meditations, :storyblok_id, :integer
    add_column :musics, :storyblok_id, :integer
  end
end
