RSpec.describe QueryTypes::TodoListQueryType do
  types = GraphQL::Define::TypeDefiner.instance
  # create fake todo lists using the todo_list factory
  let!(:todo_lists) { create_list(:todo_list_with_items, 3) }

  describe 'querying all todo lists' do
    it 'has a :todo_lists that returns a ToDoList type' do
      expect(subject).to have_field(:todo_lists).that_returns(types[Types::TodoListType])
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

  describe 'querying a specific todo_list using it\'s id' do
    it 'returns the queried todo list' do
      # set the id of list1 as the ID
      id = todo_lists.first.id
      args = { id: id }
      query_result = subject.fields['todo_list'].resolve(nil, args, nil)

      # we should only get the first todo list from the db.
      expect(query_result).to eq(todo_lists.first)
    end
  end

  describe 'querying todo list with items' do
    before(:context) do
      @query_string = "
      query {
        todo_lists {
          title
          items {
            id
            name
          }
        }
      }"
    end

    it 'has a :items field that returns a Item type' do
      results_hash = TodosGraphqlApiSchema.execute(@query_string).to_h
      data_todo = results_hash["data"]["todo_lists"]
      
      data_todo.each do |data_list|
        expect(data_list["items"]).not_to be_nil
      end
    end
    
    it 'returns all our created items' do
      results_hash = TodosGraphqlApiSchema.execute(@query_string).to_h
      data_todo = results_hash["data"]["todo_lists"]

      data_todo.each_with_index do |todo_list, i|
        expect(todo_list["title"]).to eq(todo_lists[i].title)
        todo_list["items"].each_with_index do |item, j|
          expect(item["id"]).to eq(todo_lists[i].items[j].id.to_s)
          expect(item["name"]).to eq(todo_lists[i].items[j].name)
        end
      end

      # ensure that the number of items returned is the number created
      expect(data_todo.count).to eq(todo_lists.count)
    end
  end

  describe 'querying a specific item using id' do
    it 'returns the queried item' do
      todo_num = 0
      todo_title = todo_lists[todo_num].title
      todo_ID = todo_lists[todo_num].id.to_s

      item_num = 0
      item_name = todo_lists[todo_num].items[item_num].name
      item_done = todo_lists[todo_num].items[item_num].done
      item_ID = todo_lists[todo_num].items[item_num].id.to_s
      
      query_string = "
      query {
        todo_list (id: #{todo_ID}) {
          id
          title
          item (id: #{item_ID}) {
            id
            name
            done
          }
        }
      }"

      results_hash = TodosGraphqlApiSchema.execute(query_string).to_h
      data_todo = results_hash["data"]["todo_list"]

      # check returned todo_list id
      expect(data_todo["id"]).to eq(todo_ID)
      # check returned todo_list title
      expect(data_todo["title"]).to eq(todo_title)
      # check returned item id
      expect(data_todo["item"]["id"]).to eq(item_ID)
      # check returned item name
      expect(data_todo["item"]["name"]).to eq(item_name)
      # check returned item done
      expect(data_todo["item"]["done"]).to eq(item_done)
    end
  end
end