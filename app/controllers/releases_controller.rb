class ReleasesController < ApplicationController
  skip_before_action :require_login, only: [:show]

  def show
    @release = Release.includes(mediums: :medium_format).find(params[:id])
    @q = Release.ransack(params[:q])

    music_brainz_service = MusicBrainzService.new
    @data = music_brainz_service.fetch_release_details(@release.gid)
  end
end
