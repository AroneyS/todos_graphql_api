RSpec.describe Mutations::ItemMutation do
  describe 'creating a new record' do
    # an item belongs to a todo list so we create one
    let!(:todo_list) { create(:todo_list) }

    it 'adds a new item' do
      item_name = 'An amazing name'
      args = {
        todo_list_id: todo_list.id,
        name: item_name
      }

      subject.fields['create_item'].resolve(nil, args, nil)
      # the items count increases by 1
      expect(Item.count).to eq(1)
      # the name of the most recently created item matches the value we passed
      expect(Item.last.name).to eq(item_name)
    end
  end

  describe 'editing an item' do
    let!(:todo_list) { create(:todo_list) }
    let!(:item) { create(:item, todo_list: todo_list) }
    # making an item as done
    it 'marks an item as done' do
      args = {
        id: item.id
      }
      query_result = subject.fields['mark_item_done'].resolve(nil, args, nil)

      expect(query_result.done).to eq true
    end
  end

  describe 'deleting an item' do
    let!(:todo_list) { create(:todo_list) }
    let!(:item1) { create(:item, todo_list: todo_list) }
    let!(:item2) { create(:item, todo_list: todo_list) }
    let!(:item3) { create(:item, todo_list: todo_list) }

    it 'deletes the queried item' do
      args = {
        id: item1.id
      }
      subject.fields['delete_item'].resolve(nil, args, nil)

      expect(Item.count).to eq 2
      expect(Item.all).not_to include(item1)
    end
  end
end