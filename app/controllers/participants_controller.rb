class ParticipantsController < ApplicationController
  before_action :set_group, only: [:show, :new, :edit, :create, :update, :destroy]
  before_action :set_activity, only: [:show, :new, :edit, :create, :update, :destroy]
  before_action :set_participant, only: [:show, :edit, :update, :destroy]

  # GET /participants/new
  def new
    @participant = Participant.new(friend_number: 0, derated_pay: 0)
  end

  def edit
  end

  # POST /participants
  # POST /participants.json
  def create
    @participant = @activity.participants.new(participant_params)
    respond_to do |format|
      if @participant.save
        if @activity.pay_type != Group::PAY_WITH_CARD
          @participant.activity.generate_bill
        else
          @participant.card.calculate_number unless @participant.card.nil?
      #   @participant.pay_with_card(@participant.card)
        end
        format.html { redirect_to [@group, @activity], notice: t('fees.notice.create_success') }
        format.js
      else
        format.html { redirect_to [@group, @activity], alert: t('fees.notice.create_failed') }
        format.js { render 'create_failed.js.erb' }
      end
    end
  end

  # PATCH/PUT /participants
  # PATCH/PUT /participants.json
  def update
    respond_to do |format|
      if @participant.update(participant_params)
        if @activity.pay_type != Group::PAY_WITH_CARD
          @participant.activity.generate_bill
        else
          @participant.card.calculate_number unless @participant.card.nil?
        end
        format.html { redirect_to [@group, @activity], notice: t('fees.notice.create_success') }
        format.js
      else
        format.html { redirect_to [@group, @activity], alert: t('fees.notice.create_failed') }
        format.js { render 'create_failed.js.erb' }
      end
    end
  end

  # DELETE /participants/1
  # DELETE /participants/1.json
  def destroy
    card = @participant.card
    @participant.destroy
    if @activity.pay_type != Group::PAY_WITH_CARD
      @activity.generate_bill
    else
      card.calculate_number unless card.nil?
    end
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

    def set_participant
      # set_group callback will be called FIRSTLY.
      @participant = @activity.participants.find(params[:id])
    end

    def current_resource
      @activity
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def participant_params
      params.require(:participant).permit(:user_id, :card_id, :friend_number, :derated_pay, :net_pay)
    end
end
