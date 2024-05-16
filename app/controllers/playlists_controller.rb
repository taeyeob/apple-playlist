class PlaylistsController < ApplicationController
    require 'httparty'


    def index
        @playlists = Playlist.all
    end

    def create
        # file = File.read('spotify-playlist.json')
        title = params[:title]
        description = params[:description]
        data = JSON.parse(params[:json_data])
        playlist = data["spotify_playlist"]
        tracks = data["spotify_track_information"]

        track_ids = []
        countries = []
        playlist.each do |p|
            track_info = tracks[p]
            name = track_info["name"]
            isrc = track_info["external_ids"]["isrc"]
            album = track_info["album"]["name"]
            artists = track_info["artists"].map { |artist| artist["name"] }

            # find_or_create_by를 사용하려면 available_countries가 일정해야 한다는 어려움 존재
            track = Track.find_by(name: name, album: album, isrc: isrc)
            if track.nil?
                track = Track.create(name: name, album: album, artists: artists, available_countries: track_info["available_markets"], isrc: isrc)
            end

            track_ids << track.id
            countries << track.available_countries if track.available_countries
        end

        playlist_countries = countries.reduce do |common, sublist|
            common & sublist
        end
          
        playlist = Playlist.new(title: title, description: description, track_ids: track_ids, available_countries: playlist_countries)
        
        if playlist.save
            redirect_to playlists_path, notice: 'Playlist was successfully created.'
        else
            render :new
        end
    end

    def apple_music_playlist
        @playlist = Playlist.find(params[:id])

        apple_music_track_information = {}
        tracks = @playlist.tracks
        tracks.each do |track|
            apple = track.find_song_by_isrc["data"].last
            apple_music_track_information[apple["id"]] = apple
        end
        
        # 뷰 렌더링이나 추가 로직
        render json: {
            apple_music_playlist: apple_music_track_information.keys,
            apple_music_track_information: apple_music_track_information
        }
    end
end
