# frozen_string_literal: true

class LobbyBlueprint < Blueprinter::Base
  identifier :id
  fields :status

  association :host, blueprint: UserBlueprint
  association :guest, blueprint: UserBlueprint
end
