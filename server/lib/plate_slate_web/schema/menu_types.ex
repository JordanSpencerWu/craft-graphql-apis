defmodule PlateSlateWeb.Schema.MenuTypes do
  use Absinthe.Schema.Notation

  alias PlateSlateWeb.Resolvers

  object :menu_queries do
    @desc "The list of available items on the menu"
    field :menu_items, list_of(:menu_item) do
      @desc "filter by menu item filter"
      arg(:filter, :menu_item_filter)
      @desc "order by asc or desc"
      arg(:order, type: :sort_order, default_value: :asc)
      resolve(&Resolvers.Menu.menu_items/3)
    end

    @desc "Search for menu item or category"
    field :search, list_of(:search_result) do
      @desc "matching by of menu item name or category name"
      arg(:matching, non_null(:string))
      resolve(&Resolvers.Menu.search/3)
    end
  end

  object :menu_mutations do
    @desc "Create a menu item"
    field :create_menu_item, :menu_item_result do
      @desc "Menu item input object"
      arg(:input, non_null(:menu_item_input))
      resolve(&Resolvers.Menu.create_item/3)
    end
  end

  @desc "Menu item input object"
  input_object :menu_item_input do
    field :name, non_null(:string)
    field :description, :string
    field :price, non_null(:decimal)
    field :category_id, non_null(:id)
  end

  @desc "Filtering options for the menu item list"
  input_object :menu_item_filter do
    @desc "Matching a name"
    field :name, :string

    @desc "Matching a category name"
    field :category, :string

    @desc "Matching a tag"
    field :tag, :string

    @desc "Priced above a value"
    field :priced_above, :float

    @desc "Priced below a value"
    field :priced_below, :float

    @desc "Added to the menu before this date"
    field :added_before, :date

    @desc "Added to the menu after this date"
    field :added_after, :date
  end

  @desc "A item in a menu"
  object :menu_item do
    interfaces([:search_result])
    @desc "id"
    field :id, :id
    @desc "date of when menu item was added"
    field :added_on, :date
    @desc "list of allergy information"
    field :allergy_info, list_of(:allergy_info)
    @desc "description of menu item"
    field :description, :string
    @desc "name of menu item"
    field :name, :string
    @desc "price of menu item"
    field :price, :decimal
  end

  @desc "A item's allergy information"
  object :allergy_info do
    @desc "The allergen name of item"
    field :allergen, :string
    @desc "Severity of item"
    field :severity, :string
  end

  @desc "A category of menu items"
  object :category do
    interfaces([:search_result])
    @desc "name of category"
    field :name, :string
    @desc "description of category"
    field :description, :string
    @desc "list of menu items"
    field :items, list_of(:menu_item) do
      resolve(&Resolvers.Menu.items_for_category/3)
    end
  end

  @desc "Menu item result"
  object :menu_item_result do
    @desc "Menu item"
    field :menu_item, :menu_item
    @desc "List of input error"
    field :errors, list_of(:input_error)
  end

  @desc "An error encountered trying to persist input"
  object :input_error do
    @desc "Key of input error"
    field :key, non_null(:string)
    @desc "Message of input error"
    field :message, non_null(:string)
  end
end
