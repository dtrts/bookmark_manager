feature 'viewing bookmarks' do
  scenario 'visiting the index page' do
    visit('/')
    expect(page). to have_content('Bookmark Manager')
  end
  scenario 'visiting the bookmarks page' do
    visit('/bookmarks')
    expect(page). to have_content('Goggle')
    expect(page). to have_content('FaceyB')
  end

  scenario 'adding a new bookmark and seeing it on the list' do
    visit('/bookmarks')
    click_button('Create Bookmark')
    fill_in(:title, with: 'GitHub HeartEmoji')
    fill_in(:url, with: 'https://github.com')
    click_button('Create Bookmark')

    expect(page).to have_link('GitHub HeartEmoji', href: 'https://github.com')
  end
end
