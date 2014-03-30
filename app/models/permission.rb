class Permission
  def initialize(user)
    # as guest
    allow :sessions, [:new, :create]
    allow :registrations, [:new, :create, :cancel]
    allow [:groups], [:index, :show, :members]
    allow [:activities], [:index, :show]
    allow [:card_types], [:index, :show]
    allow [:cards], [:index, :show]
    if user
      # as user
      allow :sessions, [:destroy]
      allow :registrations, [:edit, :update, :destroy, :edit_password, :update_password]
      allow :users, [:show] do |u|
        true
      # user.id == u.id
      end
      allow :users, [:index] do |u|
        user.admin?
      end
      allow :users, [:new, :create, :create_member] do |group|
        group.owned_by? user
      # group_id = user.group_id
      # group = Group.find_by group_id: group_id
      # user.id == u.id
      end
      allow :users, [:edit, :update] do |u|
        user.id == u.id or user.admin?
      end
      # groups
      allow :groups, [:new, :create]
      allow :groups, [:edit, :update, :destroy] do |group|
        group.owned_by? user
      end
      # activities
      allow :activities, [:new, :create] do |resources|
        group = resources[0]
        group.owned_by? user
      end
      # transactions
      allow :transactions, [:index, :new, :create] do |resources|
        group = resources[0]
        group.owned_by? user
      end
      # fees
      allow :fees, [:index, :new, :create] do |resources|
        group = resources[0]
        group.owned_by? user
      end
      allow :card_types, [:new, :create, :edit, :update] do |resources|
        group = resources[0]
        group.owned_by? user
      end
      allow :card_types, [:destroy] do |resources|
        group = resources[0]
        card_type = resources[1]
        group.owned_by?(user) && card_type.cards.count == 0
      end
      allow :cards, [:new, :create, :edit, :update, :destroy] do |resources|
        group = resources[0]
        group.owned_by? user
      end
      # participants
    # allow :participants, [:new, :create] do |participant|
    #   user.id == participant.user_id or 
    # end
      # as admin
      allow_all if user.admin?
    end
  end

  def allow?(controller, action, resource = nil)
    allowed = @allow_all || @allowed_actions[[controller.to_s, action.to_s]]
    allowed && (allowed == true || allowed.call(resource))
  # allowed && (allowed == true || resource && allowed.call(resource))
  end

  private

  def allow_all
    @allow_all = true
  end

  def allow(controllers, actions, &block)
    @allowed_actions ||= {}
    Array(controllers).each do |controller|
      Array(actions).each do |action|
        @allowed_actions[[controller.to_s, action.to_s]] = block || true
      end
    end
  end
end
