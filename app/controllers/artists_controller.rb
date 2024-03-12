class ArtistsController < ApplicationController
  def show
    @artist = Artist.find(params[:id])
    @q = Artist.ransack(params[:q])

    artist_credit_ids = @artist.artist_credits.pluck(:id)
    @releases = Release.where(artist_credit_id: artist_credit_ids).includes(mediums: :medium_format).page(params[:page]).per(10)

    music_brainz_service = MusicBrainzService.new
    @data = music_brainz_service.fetch_artist_details(@artist.gid)
  end
end
