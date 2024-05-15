class TracksController < ApplicationController

    def index
        @tracks = Track.where(is_playable: true)

        # render json: {
        #     tracks: data
        # }
    end
end
