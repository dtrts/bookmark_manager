describe Tag do
  it 'retrieves all tags' do
    tags = Tag.all
    expect(tags.first).to be_a(Tag)
    expect(tags.length).to eq(5)
    expect(tags.first.id).to eq('1')
    expect(tags.first.content).to eq('Great!')
  end

  it 'creates a Tag' do
    tag = Tag.create(content: 'Test tag')
    retrieved_tag = persisted_data(table: 'tags', id: 6).first
    expect(tag.id).to eq(retrieved_tag['id'])
    expect(tag.content).to eq(retrieved_tag['content'])
  end

  it 'deletes a Tag' do
    Tag.delete(id: 1)
    expect(persisted_data(table: 'tags', id: 1).first).to eq(nil)
    tags = Tag.all
    expect(tags.length).to eq(4)
  end

  it 'returns bookmarks for a tag' do
    tag = Tag.find(id: 3)
    bookmarks = tag.bookmarks
    expect(bookmarks.length).to eq(2)
    expect(bookmarks.first).to be_a(Bookmark)
    expect(bookmarks.first.title).to eq('Goggle')
    expect(bookmarks.last.title).to eq('FaceyB')
  end
end
