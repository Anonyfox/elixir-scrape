defmodule Scrape.Tools.Tree do
  @moduledoc """
  Utility module for interacting with nested Map structures, here called "tree".
  """

  @doc """
  Transform a given xml string into a tree.

  The string must be utf-8 encoded. It will be sanitized via Floki and the xml
  declaration header will be stripped.

  ## Examples
      iex> Tree.from_xml_string("<feed><item>abc</item></feed>")
      %{"feed" => %{"item" => "abc"}}
  """

  @spec from_xml_string(String.t()) :: map()

  def from_xml_string(nil), do: %{}

  def from_xml_string(xml) do
    xml
    |> String.replace(~r/<\?xml.*?>/i, "")
    |> Floki.parse()
    |> Floki.raw_html()
    |> String.trim()
    |> try_build_tree()
    |> try_normalize()
  end

  defp try_build_tree(""), do: %{}

  defp try_build_tree(xml) do
    try do
      # XMap.from_xml(xml)
      XmlToMap.naive_map(xml)
    rescue
      _ -> %{}
    end
  end

  defp try_normalize(map) do
    case Morphix.compactiform(map) do
      {:ok, tree} -> tree
      _ -> map
    end
  end

  @doc """
  Attempts all queries until one returns a non-nil result or nil.

  ## Examples
      iex> Tree.first(%{"hello" => "world"}, ["unknown"])
      nil

      iex> Tree.first(%{"hello" => "world"}, ["unknown", "hello"])
      "world"
  """

  @spec first(map(), [String.t()]) :: nil | any()

  def first(_tree, []), do: nil

  def first(tree, [selector | queries]) do
    case find(tree, selector) do
      nil -> first(tree, queries)
      [] -> first(tree, queries)
      [match] -> match
      [match | _] -> match
      match -> match
    end
  end

  @doc """
  Applies `find/2` to all given selectors and combines the result.

  ## Examples
      iex> Tree.find_all(%{"a" => "b", "c" => "d"}, ["a", "c"])
      ["b", "d"]

      iex> Tree.find_all(%{"a" => "b", "c" => "d"}, ["a", "z"])
      ["b"]

      iex> Tree.find_all(%{"a" => "b", "c" => "d"}, ["x", "y"])
      []
  """

  @spec find_all(map(), [String.t()]) :: [any()]

  def find_all(_tree, []), do: []

  def find_all(tree, selectors) do
    selectors
    |> Enum.map(&find(tree, &1))
    |> normalize()
  end

  @doc """
  Attempts to get a nested value from the tree using a string selector syntax.

  Returns nil if nothing matches the selector or all matching results.

  ## Examples
      iex> Tree.find(%{"a" => %{"b" => "c"}}, "a")
      %{"b" => "c"}

      iex> Tree.find(%{"a" => %{"b" => "c"}}, "a.b")
      "c"

      iex> Tree.find(%{"a" => %{"b" => "c"}}, "unknown")
      nil

      iex> Tree.find(%{"a" => [%{"b" => "c"}]}, "a.b")
      ["c"]

      iex> Tree.find(%{"a" => [%{"b" => [%{"c" => "d"}]}]}, "a.b.c")
      ["d"]

      iex> Tree.find(%{"a" => [%{"b" => "c"}, %{"b" => "c"}]}, "a.b")
      ["c", "c"]

      iex> Tree.find(%{"a" => [%{"b" => [%{"c" => "d"}]}]}, "a.*.c")
      ["d"]

      iex> Tree.find(%{"hello" => "world"}, "~ell")
      ["world"]
  """

  @spec find(map(), String.t()) :: any()

  def find(tree, selector) when is_map(tree) and is_binary(selector) do
    tree
    |> pick(String.split(selector, "."))
    |> normalize()
  end

  defp pick(nil, _), do: nil
  defp pick(n, []), do: n
  defp pick(n, keys) when is_list(n), do: Enum.map(n, &pick(&1, keys))
  defp pick(n, _) when not is_map(n), do: nil
  defp pick(n, ["*" | t]), do: n |> Map.values() |> Enum.map(&pick(&1, t))

  defp pick(n, ["~" <> pattern = _h | t]) do
    n
    |> Map.keys()
    |> Enum.filter(&String.contains?(&1, pattern))
    |> Enum.map(&Map.get(n, &1))
    |> Enum.map(&pick(&1, t))
  end

  defp pick(n, [h | t]) do
    case Map.get(n, h) do
      nil -> nil
      sub -> pick(sub, t)
    end
  end

  defp normalize(value) when not is_list(value), do: value

  defp normalize(value) when is_list(value) do
    value
    |> List.flatten()
    |> Enum.reject(&is_nil/1)
  end
end
