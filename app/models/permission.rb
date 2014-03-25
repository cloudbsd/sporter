class Permission
  def initialize(user)
    # as guest
    allow :sessions, [:new, :create]
    allow :registrations, [:new, :create, :cancel]
    allow [:group], [:show]
    if user
      # as user
      allow :sessions, [:destroy]
      allow :registrations, [:edit, :update, :destroy, :edit_password, :update_password]
      allow :users, [:show] do |u|
        user.id == u.id
      end
      allow :users, [:index] do |u|
        user.is_admin?
      end
      allow :users, [:edit, :update] do |u|
        user.id == u.id or user.is_admin? or user.is_moderator?
      end
      # groups
      allow :groups, [:new, :create]
      allow :groups, [:edit, :update, :destroy] do |group|
        user.is_owner? group
      end
      # participants
    # allow :participants, [:new, :create] do |participant|
    #   user.id == participant.user_id or 
    # end
      # as admin
      allow_all if user.is_admin?
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
