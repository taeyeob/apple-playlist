class AddIsrcToTracks < ActiveRecord::Migration[7.1]
  def change
    add_column :tracks, :isrc, :string
  end
end
