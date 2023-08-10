class AddMusicTagToMeditation < ActiveRecord::Migration[7.0]
  def change
    remove_reference :meditations, :music
    add_column :meditations, :music_tag, :string
  end
end
