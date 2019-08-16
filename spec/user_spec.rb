describe User do
  it 'creates a new user' do
    user = User.create(email_address: 'email@address.com', username: 'bobby_briggs_xXx', password: 'hunter2')
    user_record = persisted_data(table: 'users', id: user.id).first
    expect(user).to be_a(User)
    expect(user.id).to eq(user_record['id'])
    expect(user.username).to eq(user_record['username'])
    expect(user.email_address).to eq(user_record['email_address'])
  end

  it 'stores the password using BCrypt' do
    expect(BCrypt::Password).to receive(:create).with('hunter3')
    User.create(email_address: 'address@email.com', username: 'fabio', password: 'hunter3')
  end

  it 'returns user details on login' do
    User.create(email_address: 'email@address.com', username: 'bobby_briggs_xXx', password: 'hunter2')
    user = User.login(email_address: 'email@address.com', password: 'hunter2')
    expect(user.id).to eq('1')
    expect(user.username).to eq('bobby_briggs_xXx')
  end
end
