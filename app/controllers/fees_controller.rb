class FeesController < ApplicationController
  before_action :set_group, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_fee, only: [:edit, :update, :destroy]
# before_action :authorize_user!

  # GET /fees/new
  def new
    @fee = Fee.new
  end

  # GET /fees/1/edit
  def edit
  end

  # POST /fees
  # POST /fees.json
  def create
    @fee = @group.fees.new(fee_params)
    @fee.user = current_user
  # @fee.group = @group
    respond_to do |format|
      if @fee.save
      # format.html { redirect_to @group, notice: t('fees.notice.create_success') }
        format.html { redirect_to group_fees_path(@group), notice: t('fees.notice.create_success') }
        format.js
      else
        format.html { redirect_to @group, alert: t('fees.notice.create_failed') }
        format.js { render 'create_failed.js.erb' }
      end
    end
  end

  # PATCH/PUT /fees/1
  # PATCH/PUT /fees/1.json
  def update
    respond_to do |format|
      if @fee.update(fee_params)
        format.html { redirect_to @group, notice: 'Fee was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @fee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fees/1
  # DELETE /fees/1.json
  def destroy
    if @fee.destroy
      @msg = t('fees.notice.delete_success')
      js_file = 'destroy.js.erb'
    else
      @msg = 'Failed to delete fee.'
      js_file = 'destroy_failed.js.erb'
    end
    respond_to do |format|
      format.html { redirect_to @group, alert: @msg }
      format.js { render js_file }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:group_id])
    end

    def set_fee
      # set_group callback will be called FIRSTLY.
      @fee = @group.fees.find(params[:id])
    end

    def current_resource
      @fee
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def fee_params
      params.require(:fee).permit(:name)
    end

  # def authorize_user!
  #   fee = @fee.nil? ? Fee.new : @fee
  #   unless can? params[:action].to_sym, fee
  #     redirect_to root_path, alert: 'You have no permission to access this page.'
  #   end
  # end
end
