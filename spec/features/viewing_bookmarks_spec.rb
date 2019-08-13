feature 'viewing bookmarks' do
  scenario 'visiting the index page' do
    visit('/')
    expect(page). to have_content('Bookmark Manager')
  end
  scenario 'visiting the bookmarks page' do
    visit('/bookmarks')
    expect(page). to have_content('www.google.com')
    expect(page). to have_content('www.facebook.com')
  end

  scenario 'adding a new bookmark and seeing it on the list' do
    visit('/bookmarks')
    click_button('Add Bookmark')
    fill_in(:url,with: 'https://github.com')
    click_button('Add Bookmark')

    expect(page).to have_content('https://github.com')


  end

end

