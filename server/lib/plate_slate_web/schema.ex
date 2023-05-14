defmodule PlateSlateWeb.Schema do
  use Absinthe.Schema

  alias PlateSlate.Menu
  alias PlateSlateWeb.Schema.Middleware

  import_types(__MODULE__.AccountsTypes)
  import_types(__MODULE__.MenuTypes)
  import_types(__MODULE__.OrderingTypes)
  import_types(Absinthe.Type.Custom)

  def middleware(middleware, field, object) do
    middleware
    |> apply(:errors, field, object)
    |> apply(:get_string, field, object)
    |> apply(:debug, field, object)
  end

  defp apply(middleware, :errors, _field, %{identifier: :mutation}) do
    middleware ++ [Middleware.ChangesetErrors]
  end

  defp apply(_middleware, :get_string, field, %{identifier: :allergy_info}) do
    [{Absinthe.Middleware.MapGet, to_string(field.identifier)}]
  end

  defp apply(middleware, :debug, _field, _object) do
    if System.get_env("DEBUG") do
      [{Middleware.Debug, :start}] ++ middleware
    else
      middleware
    end
  end

  defp apply(middleware, _, _, _) do
    middleware
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Menu, Menu.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
  end

  query do
    import_fields(:accounts_queries)
    import_fields(:menu_queries)
  end

  mutation do
    import_fields(:accounts_mutations)
    import_fields(:menu_mutations)
    import_fields(:ordering_mutations)
  end

  subscription do
    import_fields(:ordering_subscriptions)
  end

  enum :sort_order do
    value(:asc)
    value(:desc)
  end

  @desc "interface for search result"
  interface :search_result do
    @desc "name of search result"
    field :name, :string

    resolve_type(fn
      %PlateSlate.Menu.Item{}, _ ->
        :menu_item

      %PlateSlate.Menu.Category{}, _ ->
        :category

      _, _ ->
        nil
    end)
  end
end
