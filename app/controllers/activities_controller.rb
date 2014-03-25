class ActivitiesController < ApplicationController
  before_action :set_group
  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  # GET /activities
  # GET /activities.json
  def index
    @activities = Activity.all
  end

  # GET /activities/1
  # GET /activities/1.json
  def show
  end

  # GET /activities/new
  def new
  # @activity = Activity.new(started_at: DateTime.now.zone.local)
    Time.zone = "Beijing"
  # @activity = Activity.new(started_at: Time.zone.now)
    @activity = Activity.new(pay_type: @group.pay_type, province: @group.province, city: @group.city, district: @group.district, location: @group.location)
    @province = Province.find_by(code: @group.province)
    @city = City.find_by(code: @group.city)
    @district = District.find_by(code: @group.district)
  end

  # GET /activities/1/edit
  def edit
  end

  # POST /activities
  # POST /activities.json
  def create
  # @activity = Activity.new(activity_params)
    @activity = @group.activities.new(activity_params)

    respond_to do |format|
      if @activity.save
      # format.html { redirect_to @group, notice: 'Activity was successfully created.' }
        format.html { redirect_to [@group, @activity], notice: 'Activity was successfully updated.' }
        format.json { render action: 'show', status: :created, location: @activity }
      else
        format.html { render action: 'new' }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /activities/1
  # PATCH/PUT /activities/1.json
  def update
    respond_to do |format|
      if @activity.update(activity_params)
        format.html { redirect_to [@group, @activity], notice: 'Activity was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /activities/1
  # DELETE /activities/1.json
  def destroy
    @activity.destroy
    respond_to do |format|
      format.html { redirect_to activities_group_url(@group) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:group_id])
    end

    def set_activity
      # set_group callback will be called FIRSTLY.
    # @activity = Activity.find(params[:id])
      @activity = @group.activities.find(params[:id])
    end

    def current_resource
      @activity
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def activity_params
      params.require(:activity).permit(:title, :started_at, :stopped_at, :applied_at, :number_limit, :pay_type, :province, :city, :district, :location, :approval, :condition)
    end
end
