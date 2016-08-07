
defmodule App.Type.Link do
  @type_string %{type: %GraphQL.Type.String{}}
  alias GraphQL.Type.ObjectType

  def type do
    %ObjectType{
        name: "Link",
        fields: %{
          id: @type_string,
          title: @type_string,
          url: @type_string,
          createdAt: %{
            type: %GraphQL.Type.String{},
            resolve: { App.Type.Link, :resolve}
          }
        }
      }
  end


  def resolve( obj, _args, _info) do
        obj.timestamp
  end
end
