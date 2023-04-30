defmodule PlateSlateWeb.Schema do
  use Absinthe.Schema

  alias PlateSlateWeb.Schema.Middleware

  import_types(Absinthe.Type.Custom)
  import_types(__MODULE__.MenuTypes)
  import_types(__MODULE__.OrderingTypes)

  def middleware(middleware, field, %{identifier: :allergy_info} = object) do
    new_middleware = {Absinthe.Middleware.MapGet, to_string(field.identifier)}
    Absinthe.Schema.replace_default(middleware, new_middleware, field, object)
  end

  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [Middleware.ChangesetErrors]
  end

  def middleware(middleware, _field, _object) do
    middleware
  end

  query do
    import_fields(:menu_queries)
  end

  mutation do
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
