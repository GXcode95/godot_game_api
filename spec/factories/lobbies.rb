# frozen_string_literal: true

# == Schema Information
#
# Table name: lobbies
#
#  id         :bigint           not null, primary key
#  status     :integer          default("pending"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  guest_id   :bigint
#  host_id    :bigint           not null
#
# Indexes
#
#  index_lobbies_on_guest_id  (guest_id) UNIQUE
#  index_lobbies_on_host_id   (host_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (guest_id => users.id)
#  fk_rails_...  (host_id => users.id)
#
FactoryBot.define do
  factory :lobby do
    association :host, factory: :user
    status { :pending }

    trait :started do
      status { :started }
      association :guest, factory: :user
    end
  end
end
