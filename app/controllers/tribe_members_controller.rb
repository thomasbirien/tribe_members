class TribeMembersController < ApplicationController
  def index
    @tribe_members = TribeMember.all
    @location = [TribeMember.first.latitude.to_f, TribeMember.first.longitude.to_f]
    # @geojson = TribeMember.build_geojson

    # respond_to do |format|
    #   format.html
    #   format.json{render json: @geojson}
    # end
  end

  def new
  end

  def create
  end

end
