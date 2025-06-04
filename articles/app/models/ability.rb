class Ability
  include CanCan::Ability

  def initialize(user)
      can :read, Article
      can :report, Article
      can [ :create, :update, :destroy ], Article, user_id: user.id
  end
end
