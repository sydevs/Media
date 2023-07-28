class CreateMusic < ActiveRecord::Migration[7.0]
  def change
    create_table :musics do |t|
      t.string :title
      t.integer :duration

      t.timestamps
    end

    add_reference :meditations, :music
  end
end
