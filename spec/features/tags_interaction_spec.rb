feature 'tags' do
  scenario 'shows the tags' do
    visit('/bookmarks')
    tag_bit = find(:xpath, '//div[@id="tag-list"]')
    expect(tag_bit).to have_content('Great!')
    expect(tag_bit).to have_link('Great!', href: '/tags/1')
    expect(tag_bit).to have_link('Read', href: '/tags/4')
  end

  scenario 'tag link shows related bookmarks' do
    visit('/bookmarks')
    tag_bit = find(:xpath, '//div[@id="tag-list"]')
    tag_bit.text
    tag_bit.click_link('Great!')
    expect(page).to have_link('MakersQueens', href: 'http://www.makersacademy.com')
    expect(page).not_to have_link('Goggle', href: 'www.google.com')
    expect(page).to have_button('All Bookmarks')
  end

  scenario 'delete a tag' do
    visit('/bookmarks')
    tag_bit = find(:xpath, '//div[@id="tag-list"]')
    expect(tag_bit).to have_content('Bad')
    tag_bit.find(:xpath, '//button[@id="tag-delete-3"]').click
    tag_bit = find(:xpath, '//div[@id="tag-list"]')
    expect(tag_bit).not_to have_content('Bad')
  end

  scenario 'add a new tag' do
    visit('/bookmarks')
    tag_bit = find(:xpath, '//div[@id="tag-list"]')
    click_on('Create Tag')
    expect(current_path).to eq('/tags/create')
    fill_in(:content, with: 'Suggested')
    click_on('Create Tag')
    expect(tag_bit).to have_link('Suggested', href: '/tags/6')
  end

  scenario 'tags are seen on a bookmark' do
    visit('/bookmarks')
    first_bookmark = find(:xpath, '//div[@id="bookmark-1"]')
    expect(first_bookmark).to have_link('Goggle', href: 'www.google.com')
    expect(first_bookmark).to have_link('Bad', href: '/tags/3')
    expect(first_bookmark).to have_link('Read', href: '/tags/4')
  end

  scenario 'delete tag from bookmark' do
    visit('/bookmarks')
    first_bookmark = find(:xpath, '//div[@id="bookmark-1"]')
    first_bookmark_first_tag = find(:xpath, '//div[@id="bookmark-1"]//div[@class="bookmark-tag"][1]')
    expect(first_bookmark).to have_link('Bad', href: '/tags/3')
    expect(first_bookmark_first_tag).to have_button('X')
    first_bookmark_first_tag.click_on('X')
    first_bookmark = find(:xpath, '//div[@id="bookmark-1"]')
    expect(first_bookmark).not_to have_link('Bad', href: '/tags/3')
  end

  scenario 'edit tags on a bookmark' do
    visit('/bookmarks')
    first_bookmark = find(:xpath, '//div[@id="bookmark-1"]')
    expect(first_bookmark).to have_button('Update Tags')
    first_bookmark.click_button('Update Tags')
    expect(current_path).to eq('/bookmarks/1/tags/update')
    expect(find(:xpath, '//input[@name="tag1"]').checked?).to eq(false)
    page.check('Great!')
    page.uncheck(:tag3)
    click_on('Edit Tags')
    first_bookmark = find(:xpath, '//div[@id="bookmark-1"]')
    expect(first_bookmark).to have_link('Great!', href: '/tags/1')
    expect(first_bookmark).not_to have_link('Bad')
  end
end
