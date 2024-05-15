class Playlist < ApplicationRecord

  def tracks
    parsed_track_ids = JSON.parse(track_ids)
    return Track.where(id: parsed_track_ids)
  end
end
