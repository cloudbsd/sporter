class GroupsController < ApplicationController
# before_action :set_group, only: [:show, :edit, :update, :destroy, :activities, :members, :transactions]
  before_action :set_group, except: [:index, :new, :create, :cities, :districts]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
  # @group = Group.new(group_params)
    @group = current_user.groups.new(group_params)

    respond_to do |format|
      if @group.save
        current_user.become_owner @group
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @group }
      else
        format.html { render action: 'new' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url }
      format.json { head :no_content }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def activities
  end

  # GET /groups/1
  # GET /groups/1.json
  def members
  end

  # GET /groups/1
  # GET /groups/1.json
  def transactions
  end

  # GET /groups/1
  # GET /groups/1.json
  def fees
  end

  # GET /groups/1
  # GET /groups/1.json
  def card_types
  end

  # GET /groups/1
  # GET /groups/1.json
  def cards
  end

  # POST /groups/1
  # POST /groups/1.json
  def cities
    options = ""
    city = Province.find_by(code: params[:province_code]).cities
    city.each do |s|
      options << "<option value=#{s.code}>#{s.name}</option>"
    end
    render :text => options
  end

  # POST /groups/1
  # POST /groups/1.json
  def districts
    options = ""
    districts = City.find_by(code: params[:city_code]).districts
    districts.each do |s|
      options << "<option value=#{s.code}>#{s.name}</option>"
    end
    render :text => options
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :pay_type, :province, :city, :district, :location, :aboutme)
    end
end
