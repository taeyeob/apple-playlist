class PlaylistsController < ApplicationController
    def index
        file = File.read('spotify-playlist.json')
        data = JSON.parse(file)
        playlist = data["spotify_playlist"]
        tracks = data["spotify_track_information"]

        track_ids = []
        countries = []
        playlist.each do |p|
            track_info = tracks[p]
            name = track_info["name"]
            album = track_info["album"]["name"]
            artists = track_info["artists"].map { |artist| artist["name"] }

            # find_or_create_by를 사용하려면 available_countries가 일정해야 한다 어려움 존재
            track = Track.find_by(name: name, album: album)
            if track.nil?
                track = Track.create(name: name, album: album, artists: artists, available_countries: track_info["available_markets"])
            end

            track_ids << track.id
            countries << track.available_countries if track.available_countries
        end

        playlist_countries = countries.reduce do |common, sublist|
            common & sublist
        end
          
        playlist = Playlist.find_by(title: 'Spotify Playlist', provider: 'spotify', provider_playlist_id: 'spotify-1')
        if playlist.nil?
            playlist = Playlist.create(title: 'Spotify Playlist', provider: 'spotify', provider_playlist_id: 'spotify-1', track_ids: track_ids, available_countries: playlist_countries)
        end

        render json: {
            data: playlist.as_json(include: :tracks)
        }
    end

    def apple_music_playlist
        @playlist = Playlist.find(params[:id])

        # provider를 'apple_music'으로 새로 생성하고 관련 데이터를 처리하는 로직
        playlist = Playlist.find_by(title: @playlist.title, provider: 'apple music', provider_playlist_id: @playlist.provider_playlist_id)
        if playlist.nil?
            playlist = Playlist.create(title: @playlist.title, provider: 'apple music', provider_playlist_id: @playlist.provider_playlist_id, track_ids: @playlist.track_ids, available_countries: @playlist.playlist_countries)
        end
        
        # 뷰 렌더링이나 추가 로직
        render json: {
            data: playlist.as_json(include: :tracks)
        }
    end
end
