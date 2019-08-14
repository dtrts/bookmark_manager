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
  scenario 'deleting a bookmark' do
    visit('/bookmarks')
    expect(page).to have_link('Goggle', href: 'www.google.com')
    first('.bookmark').click_button('Delete') # . is class and # is id
    expect(current_path).to eq('/bookmarks')
    expect(page).not_to have_link('Goggle', href: 'www.google.com')
  end

  scenario 'updating a bookmark' do
    visit('/bookmarks')
    expect(first('.bookmark')).to have_link('Goggle', href: 'www.google.com')
    first('.bookmark').click_button('Update')
    fill_in(:title, with: 'Google')
    fill_in(:url, with: 'https://www.google.com')
    click_button('Update Bookmark')

    expect(page).to have_link('Google', href: 'https://www.google.com')
  end

  scenario 'incorrectly creating a bookmark' do
    visit('/bookmarks')
    click_button('Create Bookmark')
    expect(page).not_to have_content('Invalid URL')
    fill_in(:title, with: 'This is a title')
    fill_in(:url, with: 'This is not a url')
    click_button('Create Bookmark')
    expect(page).to have_content('Invalid URL')
    expect(current_path).to eq('/bookmarks/create')
  end

  scenario 'incorrectly updating a bookmark' do
    visit('/bookmarks')
    first('.bookmark').click_button('Update')
    expect(page).not_to have_content('Invalid URL')
    fill_in(:url, with: 'Not a URL')
    click_button('Update Bookmark')

    expect(page).to have_content('Invalid URL')
    expect(current_path).to eq('/bookmarks/1/update')
  end

  scenario 'shows comments' do
    visit('/bookmarks')
    expect(first('.bookmark')).to have_content('This is a handy search engine')
  end

  scenario 'create a comment' do
    visit('/bookmarks')
    within find(:xpath, '//li[@class="bookmark"][2]') do
      click_button('Create Comment')
    end
    fill_in(:text, with: 'This is a brand new test comment')
    click_on('Create Comment')
    within find(:xpath, '//li[@class="bookmark"][2]') do
      expect(page).to have_content('This is a brand new test comment')
    end
  end

  scenario 'delete a comment' do
    visit('/bookmarks')
    within find(:xpath, '//li[@class="bookmark"][3]') do |content|
      p content
      expect(page).to have_content('Yaaaaas')
      click_on('Delete Comment')
    end
    within find(:xpath, '//li[@class="bookmark"][3]') do
      expect(page).not_to have_content('Yaaaaas')
    end
  end
end
