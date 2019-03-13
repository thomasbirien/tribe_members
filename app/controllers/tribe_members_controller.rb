class TribeMembersController < ApplicationController
  def index
    @tribe_members = TribeMember.all
    # TribeMember.build_geojson
  end

  def new
  end

  def create
  end

end
