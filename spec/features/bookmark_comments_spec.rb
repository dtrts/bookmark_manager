feature 'comments' do
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
    expect(find(:xpath, '//li[@class="bookmark"][3]')).to have_content('Yaaaaas')
    find(:xpath, '//li[@class="bookmark"][3]').click_on('Delete Comment')
    expect(find(:xpath, '//li[@class="bookmark"][3]')).not_to have_content('Yaaaaas')
  end
end
