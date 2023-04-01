defmodule PlateSlateWeb.Schema.Query.MenuItemsTest do
  use PlateSlateWeb.ConnCase, async: true

  setup do
    PlateSlate.Seeds.run()
  end

  @query """
  {
    menuItems {
      description
      name
      price
    }
  }
  """
  test "menuItems field return menu items" do
    conn = build_conn()
    conn = get conn, "/api", query: @query

    assert json_response(conn, 200) == %{
             "data" => %{
               "menuItems" => [
                 %{
                   "description" => "Description for Bánh mì",
                   "name" => "Bánh mì",
                   "price" => "4.5"
                 },
                 %{
                   "description" => "Description for Chocolate Milkshake",
                   "name" => "Chocolate Milkshake",
                   "price" => "3.0"
                 },
                 %{
                   "description" => "Description for Croque Monsieur",
                   "name" => "Croque Monsieur",
                   "price" => "5.5"
                 },
                 %{
                   "description" => "Description for French Fries",
                   "name" => "French Fries",
                   "price" => "2.5"
                 },
                 %{
                   "description" => "Description for Lemonade",
                   "name" => "Lemonade",
                   "price" => "1.25"
                 },
                 %{
                   "description" => "Description for Masala Chai",
                   "name" => "Masala Chai",
                   "price" => "1.5"
                 },
                 %{
                   "description" => "Description for Muffuletta",
                   "name" => "Muffuletta",
                   "price" => "5.5"
                 },
                 %{
                   "description" => "Description for Papadum",
                   "name" => "Papadum",
                   "price" => "1.25"
                 },
                 %{
                   "description" => "Description for Pasta Salad",
                   "name" => "Pasta Salad",
                   "price" => "2.5"
                 },
                 %{
                   "description" => "Description for Reuben",
                   "name" => "Reuben",
                   "price" => "4.5"
                 },
                 %{
                   "description" => "Description for Soft Drink",
                   "name" => "Soft Drink",
                   "price" => "1.5"
                 },
                 %{
                   "description" => "Description for Vada Pav",
                   "name" => "Vada Pav",
                   "price" => "4.5"
                 },
                 %{
                   "description" => "Description for Vanilla Milkshake",
                   "name" => "Vanilla Milkshake",
                   "price" => "3.0"
                 },
                 %{"description" => "Description for Water", "name" => "Water", "price" => "0"}
               ]
             }
           }
  end

  @query """
  {
    menuItems(filter: {name: "reu"}) {
      name
    }
  }
  """
  test "menuItems field returns menu items filtered by name" do
    response = get(build_conn(), "/api", query: @query)

    assert json_response(response, 200) == %{
             "data" => %{
               "menuItems" => [
                 %{"name" => "Reuben"}
               ]
             }
           }
  end

  @query """
  {
    menuItems(filter: {name: 123}) {
      name
    }
  }
  """
  test "menuItems field returns errors when using a bad value" do
    response = get(build_conn(), "/api", query: @query)

    assert %{
             "errors" => [
               %{"message" => message}
             ]
           } = json_response(response, 200)

    assert message ==
             "Argument \"filter\" has invalid value {name: 123}.\nIn field \"name\": Expected type \"String\", found 123."
  end

  @query """
  query ($term: String) {
    menuItems(filter: {name: $term}) {
      name
    }
  }
  """
  @variables %{"term" => "reu"}
  test "menuItems field filters by name when using a variable" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)

    assert json_response(response, 200) == %{
             "data" => %{
               "menuItems" => [
                 %{"name" => "Reuben"}
               ]
             }
           }
  end

  @query """
  {
    menuItems(order: DESC) {
      name
    }
  }
  """
  test "menuItems field returns items descending using literals" do
    response = get(build_conn(), "/api", query: @query)

    assert %{
             "data" => %{"menuItems" => [%{"name" => "Water"} | _]}
           } = json_response(response, 200)
  end

  @query """
  {
    menuItems(filter: {category: "Sandwiches", tag: "Vegetarian"}) {
      name
    }
  }
  """
  test "menuItems field returns menuItems, filtering with a literal" do
    response = get(build_conn(), "/api", query: @query)

    assert %{
             "data" => %{"menuItems" => [%{"name" => "Vada Pav"}]}
           } == json_response(response, 200)
  end

  @query """
  query ($filter: MenuItemFilter!) {
    menuItems(filter: $filter) {
      name
    }
  }
  """
  @variables %{filter: %{"tag" => "Vegetarian", "category" => "Sandwiches"}}
  test "menuItems field returns menuItems, filtering with a variable" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)

    assert %{
             "data" => %{"menuItems" => [%{"name" => "Vada Pav"}]}
           } == json_response(response, 200)
  end

  @query """
  query ($filter: MenuItemFilter!) {
    menuItems(filter: $filter) {
      name
      addedOn
    }
  }
  """
  @variables %{filter: %{"addedBefore" => "2017-01-20"}}
  test "menuItems filtered by custom scalar" do
    sides = PlateSlate.Repo.get_by!(PlateSlate.Menu.Category, name: "Sides")

    %PlateSlate.Menu.Item{
      name: "Garlic Fries",
      added_on: ~D[2017-01-01],
      price: 2.50,
      category: sides
    }
    |> PlateSlate.Repo.insert!()

    response = get(build_conn(), "/api", query: @query, variables: @variables)

    assert %{
             "data" => %{
               "menuItems" => [%{"name" => "Garlic Fries", "addedOn" => "2017-01-01"}]
             }
           } == json_response(response, 200)
  end

  @query """
  query ($filter: MenuItemFilter!) {
    menuItems(filter: $filter) {
      name
    }
  }
  """
  @variables %{filter: %{"addedBefore" => "not-a-date"}}
  test "menuItems filtered by custom scalar with error" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)

    assert %{
             "errors" => [
               %{
                 "locations" => [
                   %{"column" => 13, "line" => 2}
                 ],
                 "message" => message
               }
             ]
           } = json_response(response, 200)

    expected = """
    Argument "filter" has invalid value $filter.
    In field "addedBefore": Expected type "Date", found "not-a-date".\
    """

    assert expected == message
  end

  @query """
  query ($filter: MenuItemFilter!) {
    menuItems(filter: $filter) {
      name
    }
  }
  """
  @variables %{filter: %{"addedBefore" => 123}}
  test "menuItems filtered by custom scalar handles non strings" do
    response = get(build_conn(), "/api", query: @query, variables: @variables)

    assert %{
             "errors" => [
               %{"locations" => [%{"column" => 13, "line" => 2}], "message" => message}
             ]
           } = json_response(response, 200)

    assert "Argument \"filter\" has invalid value $filter.\nIn field \"addedBefore\": Expected type \"Date\", found \"123\"." ==
             message
  end
end
