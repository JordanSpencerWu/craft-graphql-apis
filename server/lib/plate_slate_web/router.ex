defmodule PlateSlateWeb.Router do
  use PlateSlateWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/api", Absinthe.Plug, schema: PlateSlateWeb.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: PlateSlateWeb.Schema,
      interface: :simple,
      socket: PlateSlateWeb.UserSocket
  end
end
