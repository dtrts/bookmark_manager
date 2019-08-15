describe BookmarkTag do
  it 'finds on bookmark' do
    bmts = BookmarkTag.find_on_bookmark(id: 1)
    expect(bmts.first).to be_a(BookmarkTag)
    expect(bmts.length).to eq(2)
    expect(bmts.first.id).to eq('1')
    expect(bmts.first.tag_id).to eq('3')
  end

  it 'finds on tag' do
    bmts = BookmarkTag.find_on_tag(id: 1)
    expect(bmts.first).to be_a(BookmarkTag)
    expect(bmts.length).to eq(1)

    expect(bmts.first.id).to eq('4')
    expect(bmts.first.bookmark_id).to eq('3')
  end

  it 'creates a relation' do
    bmt = BookmarkTag.create(bookmark_id: 1, tag_id: 1)
    new_bmt = persisted_data(table: 'bookmark_tags', id: 7).first
    expect(bmt.id).to eq(new_bmt['id'])
    expect(bmt.bookmark_id).to eq(new_bmt['bookmark_id'])
    expect(bmt.tag_id).to eq(new_bmt['tag_id'])
  end

  it 'creates a relation but will not duplicate it if it exists' do
    BookmarkTag.create(bookmark_id: 1, tag_id: 1)
    res = BookmarkTag.create(bookmark_id: 1, tag_id: 1)
    expect(persisted_data(table: 'bookmark_tags', id: 8).first).to eq(nil)
    expect(res).to eq(false)
  end

  it 'deletes a single relation, even if it isn\'t there' do
    BookmarkTag.delete(bookmark_id: 1, tag_id: 3)
    res = persisted_data(table: 'bookmark_tags', id: 1).first
    expect(res).to eq(nil)
    BookmarkTag.delete(bookmark_id: 1, tag_id: 3)
  end
end
