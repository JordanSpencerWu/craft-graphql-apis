defmodule PlateSlateWeb.Resolvers.Menu do
  alias PlateSlate.Menu
  alias PlateSlate.Repo

  def menu_items(_parent, args, _resolution) do
    {:ok, Menu.list_items(args)}
  end

  def items_for_category(category, _args, _resolution) do
    query = Ecto.assoc(category, :items)
    {:ok, Repo.all(query)}
  end

  def search(_parent, %{matching: term}, _resolution) do
    {:ok, Menu.search(term)}
  end

  def create_item(_parent, %{input: params}, _resolution) do
    case Menu.create_item(params) do
      {:error, changeset} ->
        {:ok, %{errors: transform_errors(changeset)}}

      {:ok, menu_item} ->
        {:ok, %{menu_item: menu_item}}
    end
  end

  defp transform_errors(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(&format_error/1)
    |> Enum.map(fn
      {key, value} ->
        %{key: key, message: value}
    end)
  end

  defp format_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
