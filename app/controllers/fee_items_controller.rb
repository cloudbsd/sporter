class FeeItemsController < ApplicationController
  before_action :set_group, only: [:show, :new, :edit, :create, :update, :destroy]
  before_action :set_activity, only: [:show, :new, :edit, :create, :update, :destroy]
  before_action :set_fee_item, only: [:show, :edit, :update, :destroy]

  # GET /fee_items/new
  def new
    @fee_item = FeeItem.new
  end

  # POST /fee_items
  # POST /fee_items.json
  def create
    @fee_item = @activity.fee_items.new(fee_item_params)
    respond_to do |format|
      if @fee_item.save
        format.html { redirect_to [@group, @activity], notice: t('fees.notice.create_success') }
        format.js
      else
        format.html { redirect_to @group, alert: t('fees.notice.create_failed') }
        format.js { render 'create_failed.js.erb' }
      end
    end
  end

  def edit
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:group_id])
    end

    def set_activity
      # set_group callback will be called FIRSTLY.
    # @activity = Activity.find(params[:id])
      @activity = @group.activities.find(params[:activity_id])
    end

    def set_fee_item
      # set_group callback will be called FIRSTLY.
    # @activity = Activity.find(params[:id])
      @activity = @activity.fee_items.find(params[:id])
    end

    def current_resource
      @activity
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fee_item_params
      params.require(:fee_item).permit(:fee_id, :price)
    end
end
