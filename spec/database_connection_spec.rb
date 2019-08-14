require 'database_connection'

describe DatabaseConnection do
  it 'sets up a new database connection using PG' do
    expect(PG).to receive(:connect).with(dbname: 'bookmark_manager_test')
    DatabaseConnection.setup('bookmark_manager_test')
  end
  it 'returns results from a query' do
    DatabaseConnection.setup('bookmark_manager_test')
    expect(DatabaseConnection.query('select id from bookmarks;').first).to eq('id' => '1')
  end
end
