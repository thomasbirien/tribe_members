class TribeMembersController < ApplicationController
  def index
    if params[:name].present? || params[:surname] || params[:member_birthdate] || params[:ancestor_name]
      @search_result = TribeMember.search(params)
    else
      @tribe_m = TribeMember.all.paginate(:page => params[:page], :per_page => 15)
    end
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
    @data_graph = Stat.prepare_hash
  end

  private

  def tribe_member_params
    params.require(:tribe_member).permit(:name, :surname, :birthdate, :latitude, :longitude)
  end

end
