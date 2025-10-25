# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?

    can [:update, :destroy], Lobby, guest_id: user.id
    can :manage, Lobby, host_id: user.id
  end
end
