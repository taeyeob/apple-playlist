class CreatePlaylists < ActiveRecord::Migration[7.1]
  def change
    create_table :playlists do |t|
      t.string :title
      t.string :description
      t.string :track_ids
      t.string :available_countries, default: '{}'

      t.timestamps
    end
  end
end
