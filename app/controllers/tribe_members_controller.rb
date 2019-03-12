class TribeMembersController < ApplicationController
  def index
    @tribe_members = TribeMember.all
    @locations = TribeMember.set_location_array
  end

  def new
  end

  def create
  end

end
