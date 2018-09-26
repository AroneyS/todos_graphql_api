RSpec.describe QueryTypes::TodoListQueryType do
  describe 'querying todo list with items' do
    let!(:todo_list) { create(:todo_list) }
    let!(:item_list) { create_list(:item, 3, todo_list: todo_list) }

    it 'has an :items field that returns an Item type' do
      expect(Types::TodoListType).to have_field(:items)#.that_returns(types[Types::ItemType])
    end

    it 'returns our created items' do
      query_result = Types::TodoListType.fields['items'].resolve(todo_list, nil, nil)

      item_list.each do |item|
        expect(query_result.to_a).to include(item)
      end
    end
  end

  describe 'querying a specific item using id' do
    let!(:todo_list) { create(:todo_list) }
    let!(:item1) { create(:item, todo_list: todo_list) }
    let!(:item2) { create(:item, todo_list: todo_list) }

    it 'returns the queried item' do
      args = {
        id: item1.id
      }
      query_result = Types::TodoListType.fields['item'].resolve(todo_list, args, nil)

      expect(query_result).to eq(item1)
      expect(query_result).not_to eq(item2)
    end
  end
end