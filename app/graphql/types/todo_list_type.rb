module Types
  TodoListType = GraphQL::ObjectType.define do
    name 'TodoListType'
    description 'The Todo List type'

    field :id, !types.ID
    field :title, !types.String
    field :items, types[Types::ItemType] do
      resolve ->(obj, _args, _ctx) { obj.items }
    end
    field :item, Types::ItemType, 'returns the queried item' do
      argument :id, !types[types.ID]

      resolve ->(obj, args, _ctx) { obj.items.find_by!(id: args[:id]) }
    end
  end
end