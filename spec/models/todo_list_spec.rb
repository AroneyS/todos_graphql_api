RSpec.describe TodoList, type: :model do
  it 'has a valid factory' do
    expect(build(:todo_list)).to be_valid
  end

  it 'has a valid with_items factory' do
    expect(build(:todo_list_with_items)).to be_valid
  end

  let(:attributes) do
    {
      title: 'A test title'
    }
  end

  let(:todo_list) { create(:todo_list, **attributes) }

  describe 'model validations' do
    # check that the title field received the right values
    it { expect(todo_list).to allow_value(attributes[:title]).for(:title) }
    # ensure that the title field is never empty
    it { expect(todo_list).to validate_presence_of(:title) }
    # ensure that the title is unique for each todo list
    it { expect(todo_list).to validate_uniqueness_of(:title) }
  end

  describe 'model associations' do
    # ensure a todo list has many items
    it { expect(todo_list).to have_many(:items) }
  end

  let(:new_attributes) do
    {
      title:       'A new test title',
      item_count:       5
    }
  end

  let(:todo_list_with_items) { create(:todo_list_with_items, **new_attributes) }

  describe 'generated model associations' do
    # check that the title is applied correctly
    it { expect(todo_list_with_items).to allow_value(new_attributes[:title]).for(:title) }
    # check that the title has correct number of associated items
    it 'should have correct number of items' do
      expect(todo_list_with_items.items.count).to eq(new_attributes[:item_count])
    end
    # ensure that the objects in items are associate with the todo_list
    it 'contains items that reference correct todo_list' do
      todo_list_with_items.items.each do |item|
        expect(item.todo_list_id).to eq(todo_list_with_items.id)
      end
    end
  end
end
