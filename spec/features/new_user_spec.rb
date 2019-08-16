feature 'New User' do
  scenario 'registering as a user' do
    visit('/bookmarks')
    click_on('User Registration')
    fill_in('Username:', with: 'bobby_briggs_xXx')
    fill_in('Password:', with: 'hunter2')
    click_on('Register')
    expect(page).not_to have_xpath('//img[@src="/__sinatra__/500.png"]')
    expect(page).to have_content('bobby_briggs_xXx')
  end
end
