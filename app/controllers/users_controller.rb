class UsersController < ApplicationController
  skip_before_filter :authenticate_user!, :only => [:index, :show]

  before_action :set_user, only: [:show, :edit, :update]
  before_action :authorize_user!

  # GET /users
  # GET /users.json
  def index
    @users = User.all
#   @users = User.all.paginate(:page => params[:page], :per_page => 16)
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @group = Group.find params[:group_id]
    @user = User.new
  end

  # GET /users/1
  # GET /users/1.json
  def edit
  end

  # POST /users
  # POST /users.json
  def create_member
    @group = Group.find params[:group_id]
    @user = User.new(user_params)
    @user.password = 'password'
    respond_to do |format|
      if @user.save
        group = Group.find params[:group_id]
        group.users << @user
        format.html { redirect_to members_group_path(group), notice: t('users.notice.created') }
        format.json { render action: 'show', status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User account was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /users/1
  # POST /users/1.json
  def cards
    group_id = params[:group_id]
    cash_price = Group.find_by(id: group_id).price
    options = ""
    cards = User.find_by(id: params[:id]).cards.in_group(group_id)
    cards.each do |c|
      if c.is_debit_card?
        options << "<option value=#{c.id}>#{c.card_type.name} / #{c.remaining_number}</option>"
      elsif c.is_cash_card?
        options << "<option value=#{c.id}>#{c.card_type.name} / #{cash_price}</option>"
        cash_price = nil
      else
        options << "<option value=#{c.id}>#{c.card_type.name} / #{c.remaining_number.to_i}</option>"
      end
    end
    unless cash_price.nil?
      options << "<option value>#{I18n.t('card_types.type.cash')} / #{cash_price}</option>"
    end
    render :text => options
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def current_resource
      @group = Group.find_by id: params[:group_id]
    # @user = User.new(user_params) if @user.nil?
      @user || @group
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :name, :birthday, :gender, :mobile, :telephone, :gravatar, :province, :city, :district, :location, :aboutme)
    end
end
