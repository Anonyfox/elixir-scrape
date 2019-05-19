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
    |> Floki.parse()
    |> Floki.raw_html()
    |> String.replace(~r/<\?xml.*?>/i, "")
    |> String.trim()
    |> try_build_tree()
    |> try_normalize()
  end

  defp try_build_tree(""), do: %{}

  defp try_build_tree(xml) do
    try do
      XMap.from_xml(xml)
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
end
