class TribeMembersController < ApplicationController
  def index
    if params[:name].present? || params[:surname] || params[:member_birthdate] || params[:ancestor_name]
      @search_result = TribeMember.search(params)
    else
      # @tribe_m = JSON.parse(File.read('public/tribe_members.json'))
      # respond_to do |format|
      #   format.html
      #   format.json { render json: @tribe_m }
      # end
      @tribe_m = TribeMember.all.paginate(:page => params[:page], :per_page => 40)
    end
    # @tribe_members = TribeMember.all
    # TribeMember.build_geojson
  end

  def new
    raise
  end


  def create
  end

end
