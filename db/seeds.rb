# frozen_string_literal: true

user = User.find_or_initialize_by(email: 'user@mail.io')
if user.new_record?
  user.nickname = 'default_user'
  user.password = 'password'
  user.password_confirmation = 'password'
  user.save!
end

users = []
6.times do |i|
  u = User.find_or_initialize_by(email: "user#{i}@mail.io")
  if u.new_record?
    u.nickname = "user#{i}"
    u.password = 'password'
    u.password_confirmation = 'password'
    u.save!
  end
  users << u
end

2.times do
  Lobby.find_or_create_by(host_id: users.shift.id, guest_id: users.shift.id, status: :pending)
end
Lobby.find_or_create_by(host_id: users.shift.id, guest_id: users.shift.id, status: :started)
