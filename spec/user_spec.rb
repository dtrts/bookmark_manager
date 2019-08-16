describe User do
  it 'creates a new user' do
    user = User.create(username: 'bobby_briggs_xXx', password: 'hunter2')
    user_record = persisted_data(table: 'users', id: user.id).first
    expect(user).to be_a(User)
    expect(user.id).to eq(user_record['id'])
    expect(user.username).to eq(user_record['username'])
  end
end
