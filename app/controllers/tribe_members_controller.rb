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
      @tribe_m = TribeMember.all.paginate(:page => params[:page], :per_page => 13)
    end
    # @tribe_members = TribeMember.all
    # TribeMember.build_geojson
  end

  def new
    @tribe_member = TribeMember.new
  end


  def create
    ancestor = TribeMember.where(name: params[:tribe_member][:ancestor_name], surname: params[:tribe_member][:ancestor_surname]).first
    @tribe_member = TribeMember.new(tribe_member_params)
    @tribe_member.ancestor = ancestor
    if @tribe_member.save
      TribeMember.add_to_stats(@tribe_member)
      TribeMember.add_to_geojson(@tribe_member)
      redirect_to tribe_members_path
    else
      render :new
    end
  end

  def show_stats
    @stats = TribeMember.data_parse
  end

  private

  def tribe_member_params
    params.require(:tribe_member).permit(:name, :surname, :birthdate, :latitude, :longitude)
  end

end
