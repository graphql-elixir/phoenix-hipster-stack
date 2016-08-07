defmodule App.Type.Store do

  alias GraphQL.Schema
  alias GraphQL.Type.ObjectType

  alias GraphQL.Relay.Node
  alias GraphQL.Relay.Connection
  alias GraphQL.Relay.Mutation
  import RethinkDB.Query, only: [table: 1]
  alias RethinkDB.Query
  @type_string %{type: %GraphQL.Type.String{}}
  import RethinkDB.Lambda

  alias GraphQL.Type.ID
  alias GraphQL.Type.NonNull

  def type do
    %ObjectType{
      name: "Store",
      fields: %{
        id: Node.global_id_field("Store"),
        linkConnection: %{
          type: App.Type.LinkConnection.get[:connection_type],
          args: Map.merge(Connection.args, %{query: @type_string}),
          resolve: {App.Type.Store, :resolve}
        }
      },
      interfaces: [App.PublicSchema.node_interface]
    }
  end


  def resolve( _, args , _ctx) do
        query = table("links")
          |> Query.filter( lambda fn(link) ->  Query.match(link[:title],args[:query]) end)
          |> Query.order_by(Query.desc("timestamp"))
          |> DB.run
          |> DB.handle_graphql_resp
      Connection.List.resolve(query, args)
  end
end
