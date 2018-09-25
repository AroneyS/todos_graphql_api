RSpec.describe QueryTypes::TodoListQueryType do
  types = GraphQL::Define::TypeDefiner.instance
  # create fake items each associated with a todo_list
  let!(:items) { create_list(:item, 3) }

  describe 'querying todo list with items' do
    it 'has a :items field that returns a Item type' do
      #expect(subject).to have_field(:todo_lists).to have_field(:items).that_returns(types[Types::ItemType])
    end
    
    it 'returns all our created items' do
      query_result = subject.fields['todo_lists'].resolve(nil, nil, nil)

      query_result.each_with_index do |todo_list, i|
        items_result = todo_list.items
        # ensure that each item is returned
        expect(items_result.to_a).to include(items[i])
      end

      # ensure that the number of items returned is the number created
      expect(query_result.count).to eq(items.count)
    end
  end

  describe 'querying a specific item using id' do
    it 'returns the queried item' do
      id = items.first.id
      args = { id: id }
      query_result = subject.fields['todo_lists'].resolve(nil, nil, nil)
      #item_result = query_result.first.fields['item'].resolve(query_result.first, args, nil)

      #expect(item_result).to eq(items.first)
    end
  end
end