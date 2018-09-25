RSpec.describe Types::ItemType do
  types = GraphQL::Define::TypeDefiner.instance

  it 'has an :id field of ID type' do
    # Ensure that the field id is of type ID
    expect(subject).to have_field(:id).that_returns(!types.ID)
  end

  it 'has a :name field of String type' do
    # Ensure that the field name is of type String
    expect(subject).to have_field(:name).that_returns(!types.String)
  end

  it 'has a :done field of Boolean type' do
    # Ensure that the field done is of type Boolean
    expect(subject).to have_field(:done).that_returns(!types.Boolean)
  end
end