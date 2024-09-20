class AddUuidToMusic < ActiveRecord::Migration[7.0]
  def up
    add_column :musics, :uuid, :string
    Music.all.each do |m|
      m.update_column :uuid, SecureRandom.hex(5) + m.id.to_s
    end
  end
  def down
    remove_column :musics, :uuid
  end
end
