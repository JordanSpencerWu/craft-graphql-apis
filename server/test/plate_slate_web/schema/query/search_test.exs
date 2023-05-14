defmodule PlateSlateWeb.Schema.Query.SearchTest do
  use PlateSlateWeb.ConnCase, async: true

  setup do
    PlateSlate.Seeds.run()
  end

  @query """
  query Search($term: String!) {
    search(matching: $term) {
      name
      ... on Category {
        items(filter: {name: "F"}) {
          name
        }
      }
      __typename
    }
  }
  """
  @variables %{term: "e"}
  test "search returns a list of menu items and categories" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)
    assert %{"data" => %{"search" => results}} = json_response(response, 200)
    assert length(results) > 0
    assert Enum.find(results, &(&1["__typename"] == "Category"))
    assert Enum.find(results, &(&1["__typename"] == "MenuItem"))
    assert Enum.all?(results, & &1["name"])

    assert results == [
             %{"__typename" => "MenuItem", "name" => "Reuben"},
             %{"__typename" => "MenuItem", "name" => "Croque Monsieur"},
             %{"__typename" => "MenuItem", "name" => "Muffuletta"},
             %{"__typename" => "MenuItem", "name" => "Bánh mì"},
             %{"__typename" => "MenuItem", "name" => "Vada Pav"},
             %{"__typename" => "MenuItem", "name" => "French Fries"},
             %{"__typename" => "MenuItem", "name" => "Papadum"},
             %{"__typename" => "MenuItem", "name" => "Pasta Salad"},
             %{"__typename" => "MenuItem", "name" => "Water"},
             %{"__typename" => "MenuItem", "name" => "Soft Drink"},
             %{"__typename" => "MenuItem", "name" => "Lemonade"},
             %{"__typename" => "MenuItem", "name" => "Masala Chai"},
             %{"__typename" => "MenuItem", "name" => "Vanilla Milkshake"},
             %{"__typename" => "MenuItem", "name" => "Chocolate Milkshake"},
             %{
               "__typename" => "Category",
               "items" => [%{"name" => "Muffuletta"}],
               "name" => "Sandwiches"
             },
             %{
               "__typename" => "Category",
               "items" => [%{"name" => "French Fries"}],
               "name" => "Sides"
             },
             %{
               "__typename" => "Category",
               "items" => [%{"name" => "Soft Drink"}],
               "name" => "Beverages"
             }
           ]
  end
end
