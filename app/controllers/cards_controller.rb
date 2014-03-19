class CardsController < ApplicationController
  before_action :set_group, only: [:show, :new, :edit, :create, :update, :destroy]
  before_action :set_card, only: [:show, :edit, :update, :destroy]

  # GET /cards/new
  def new
    @card = Card.new
  end

  def edit
  end

  # POST /cards
  # POST /cards.json
  def create
    @card = Card.new(card_params)
    respond_to do |format|
      if @card.save
        format.html { redirect_to group_cards_path(@group), notice: t('cards.notice.create_success') }
        format.js
      else
        format.html { redirect_to @group, alert: t('cards.notice.create_failed') }
        format.js { render 'create_failed.js.erb' }
      end
    end
  end

  # PATCH/PUT /cards
  # PATCH/PUT /cards.json
  def update
    respond_to do |format|
      if @card.update(card_params)
        format.html { redirect_to group_cards_path(@group), notice: t('cards.notice.create_success') }
        format.js
      else
        format.html { redirect_to group_cards_path(@group), alert: t('cards.notice.create_failed') }
        format.js { render 'create_failed.js.erb' }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    @card.destroy
    respond_to do |format|
      format.html { redirect_to group_cards_path(@group) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:group_id])
    end

    def set_card
      @card = Card.find(params[:id])
    end

    def current_resource
      @card
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def card_params
      params.require(:card).permit(:user_id, :card_type_id, :started_at, :stopped_at, :number)
    end
end
