feature 'New User' do
  scenario 'registering as a user' do
    visit('/bookmarks')
    click_on('User Registration')
    fill_in('Email Address:', with: 'email@address.com')
    fill_in('Username:', with: 'bobby_briggs_xXx')
    fill_in('Password:', with: 'hunter2')
    click_on('Register')
    expect(page).not_to have_xpath('//img[@src="/__sinatra__/500.png"]')
    expect(page).to have_content('bobby_briggs_xXx')
  end

  scenario 'signs into user account' do
    User.create(email_address: 'ladsladslads@bible.com', username: 'TopLad', password: 'im_so_lonely')
    visit('/bookmarks')
    click_on('User Login')
    fill_in('Email Address:', with: 'ladsladslads@bible.com')
    fill_in('Password:', with: 'im_so_lonely')
    click_on('Login')
    expect(page).not_to have_button('User Login')
    expect(page).not_to have_xpath('//img[@src="/__sinatra__/500.png"]')
    expect(page).to have_content('TopLad')
  end

  scenario ' signs out of account' do
    User.create(email_address: 'ladsladslads@bible.com', username: 'TopLad', password: 'im_so_lonely')
    visit('/bookmarks')
    click_on('User Login')
    fill_in('Email Address:', with: 'ladsladslads@bible.com')
    fill_in('Password:', with: 'im_so_lonely')
    click_on('Login')
    click_on('Logout')
    expect(page).not_to have_xpath('//img[@src="/__sinatra__/500.png"]')
    expect(page).not_to have_content('TopLad')
    expect(page).not_to have_button('Logout')
    expect(page).to have_xpath('//div[@id="logout-message"]')
  end

  scenario 'shows error on incorrect password' do
    User.create(email_address: 'ladsladslads@bible.com', username: 'TopLad', password: 'im_so_lonely')
    visit('/bookmarks')
    click_on('User Login')
    fill_in('Email Address:', with: 'ladsladslads@bible.com')
    fill_in('Password:', with: 'im_so_lovely')
    click_on('Login')
    expect(page).to have_content('Invalid Email or Password')
  end
end
