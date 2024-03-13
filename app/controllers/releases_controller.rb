class ReleasesController < ApplicationController
  def show
    @release = Release.find(params[:id])
    @q = Release.ransack(params[:q])

    music_brainz_service = MusicBrainzService.new
    @data = music_brainz_service.fetch_release_details(@release.gid)
  end
end
