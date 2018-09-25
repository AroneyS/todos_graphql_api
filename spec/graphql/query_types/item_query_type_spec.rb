RSpec.describe QueryTypes::TodoListQueryType do
  types = GraphQL::Define::TypeDefiner.instance
  # create fake items each associated with a todo_list
  let!(:items) { create_list(:item, 3) }

  describe 'querying todo list with items' do
=begin
    it 'has a :items field that returns a Item type' do
      #query_result = subject.fields['todo_lists'].resolve(nil, nil, nil)
      subject { TodoListType.fields['items'].resolve(TodoListType, nil, nil) }
      expect(subject).to have_field(:items).that_returns(types[Types::ItemType])
      #query_result.each do |todo_list|
      #  expect(todo_list).to have_field(:items).that_returns(types[Types::ItemType])
      #end
    end
=end
    
    it 'returns all our created items' do
      query_result = subject.fields['todo_lists'].resolve(nil, nil, nil)
=begin
      query_result.each do |todo_list|
        items_result = todo_list.items.resolve(todo_list, nil, nil)
        # ensure that each item is returned
        items.each do |item|
          expect(items_result.to_a).to include(item)
        end
      end
=end

      # ensure that the number of items returned is the number created
      #expect(query_result.count).to eq(items.count)
    end
  end
end


=begin
  describe 'querying all todo lists' do
    it 'has a :todo_lists that returns a ToDoList type' do
      expect(subject).to have_field(:todo_lists).
      that_returns(types[Types::TodoListType])
    end
    
    it 'returns all our created todo lists' do
      query_result = subject.fields['todo_lists'].resolve(nil, nil, nil)

      # ensure that each of our todo lists are returned
      todo_lists.each do |list|
        expect(query_result.to_a).to include(list)
      end

      # ensure that the number of lists returned is the number created
      expect(query_result.count).to eq(todo_lists.count)
    end
  end
=end