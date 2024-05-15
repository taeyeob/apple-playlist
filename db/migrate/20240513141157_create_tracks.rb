class CreateTracks < ActiveRecord::Migration[7.1]
  def change
    create_table :tracks do |t|
      t.string :name, null: false
      t.json :artists, default: '{}'
      t.string :album, null: false
      t.boolean :is_playable, default: true
      t.json :available_countries, default: '{}'

      t.timestamps
    end
  end
end
