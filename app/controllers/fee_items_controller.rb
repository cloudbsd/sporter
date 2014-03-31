class FeeItemsController < ApplicationController
  before_action :set_group
  before_action :set_activity
  before_action :set_fee_item, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!

  # GET /fee_items/new
  def new
    @fee_item = FeeItem.new
  end

  def edit
  end

  # POST /fee_items
  # POST /fee_items.json
  def create
    @fee_item = @activity.fee_items.new(fee_item_params)
    respond_to do |format|
      if @fee_item.save
        @fee_item.activity.generate_bill
        format.html { redirect_to [@group, @activity], notice: t('fees.notice.create_success') }
        format.js
      else
        format.html { redirect_to @group, alert: t('fees.notice.create_failed') }
        format.js { render 'create_failed.js.erb' }
      end
    end
  end

  # PATCH/PUT /fee_items
  # PATCH/PUT /fee_items.json
  def update
    respond_to do |format|
      if @fee_item.update(fee_item_params)
        @fee_item.activity.generate_bill
        format.html { redirect_to [@group, @activity], notice: t('fees.notice.create_success') }
        format.js
      else
        format.html { redirect_to [@group, @activity], alert: t('fees.notice.create_failed') }
        format.js { render 'create_failed.js.erb' }
      end
    end
  end

  # DELETE /fee_items/1
  # DELETE /fee_items/1.json
  def destroy
    @fee_item.destroy
    @fee_item.activity.generate_bill
    respond_to do |format|
      format.html { redirect_to [@group, @activity] }
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
      @activity = @group.activities.find(params[:activity_id])
    end

    def set_fee_item
      # set_group callback will be called FIRSTLY.
    # @activity = Activity.find(params[:id])
      @fee_item = @activity.fee_items.find(params[:id])
    end

    def current_resource
      [@group, @activity, @fee_item]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fee_item_params
      params.require(:fee_item).permit(:fee_id, :price)
    end
end
