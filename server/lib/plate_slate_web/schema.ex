defmodule PlateSlateWeb.Schema do
  use Absinthe.Schema

  import_types(Absinthe.Type.Custom)
  import_types(__MODULE__.MenuTypes)

  query do
    import_fields(:menu_queries)
  end

  mutation do
    import_fields(:menu_mutations)
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
