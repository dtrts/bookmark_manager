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
  it 'creates a useable connection' do
    connection = DatabaseConnection.setup('bookmark_manager_test')
    expect(DatabaseConnection.connection).to eq(connection)
  end
  it 'executes a query via PG' do
    connection = DatabaseConnection.setup('bookmark_manager_test')

    expect(connection).to receive(:exec).with('SELECT * FROM bookmarks;')

    DatabaseConnection.query('SELECT * FROM bookmarks;')
  end
end
