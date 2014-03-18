class CardTypesController < ApplicationController
  before_action :set_group, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_card_type, only: [:edit, :update, :destroy]
# before_action :authorize_user!

  # GET /card_types/new
  def new
    @card_type = CardType.new(number: 0)
  end

  # GET /card_types/1/edit
  def edit
  end

  # POST /card_types
  # POST /card_types.json
  def create
    @card_type = @group.card_types.new(card_type_params)
  # @card_type.group = @group
    respond_to do |format|
      if @card_type.save
      # format.html { redirect_to @group, notice: t('card_types.notice.create_success') }
        format.html { redirect_to group_card_types_path(@group), notice: t('card_types.notice.create_success') }
        format.js
      else
        format.html { redirect_to @group, alert: t('card_types.notice.create_failed') }
        format.js { render 'create_failed.js.erb' }
      end
    end
  end

  # PATCH/PUT /card_types/1
  # PATCH/PUT /card_types/1.json
  def update
    respond_to do |format|
      if @card_type.update(card_type_params)
        format.html { redirect_to @group, notice: 'Fee was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @card_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /card_types/1
  # DELETE /card_types/1.json
  def destroy
    if @card_type.can_be_delete?
      if @card_type.destroy
        @msg = t('card_types.notice.delete_success')
        js_file = 'destroy.js.erb'
      else
        @msg = 'Failed to delete card_type.'
        js_file = 'destroy_failed.js.erb'
      end
    else
      @msg = 'You can NOT delete card_types that have been accepted.'
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

    def set_card_type
      # set_group callback will be called FIRSTLY.
      @card_type = @group.card_types.find(params[:id])
    end

    def current_resource
      @card_type
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_type_params
      params.require(:card_type).permit(:name, :group_id, :price, :duration, :number)
    end

  # def authorize_user!
  #   card_type = @card_type.nil? ? Fee.new : @card_type
  #   unless can? params[:action].to_sym, card_type
  #     redirect_to root_path, alert: 'You have no permission to access this page.'
  #   end
  # end
end
