defmodule Scrape.Flow.Feed do
  @moduledoc false

  alias Scrape.Flow
  alias Scrape.IR.Feed

  def from_url(url, opts \\ []) do
    Flow.start(opts)
    |> Flow.assign(url: url)
    |> Flow.assign(xml: &Scrape.Source.HTTP.get!(&1[:url]))
    |> process_xml()
  end

  def from_file(path, opts \\ []) do
    Flow.start(opts)
    |> Flow.assign(path: path)
    |> Flow.assign(url: nil)
    |> Flow.assign(xml: &Scrape.Source.Disk.get!(&1[:path]))
    |> process_xml()
  end

  def from_string(xml, opts \\ []) do
    Flow.start(opts)
    |> Flow.assign(xml: xml)
    |> Flow.assign(url: nil)
    |> process_xml()
  end

  defp process_xml(%{assigns: %{xml: nil}}), do: {:error, :xml_invalid}

  defp process_xml(%{assigns: %{xml: ""}}), do: {:error, :xml_invalid}

  defp process_xml(flow) do
    flow
    |> Flow.assign(tree: &Scrape.Tools.Tree.from_xml_string(&1[:xml]))
    |> Flow.assign(title: &Feed.title(&1[:tree]))
    |> Flow.assign(description: &Feed.description(&1[:tree]))
    |> Flow.assign(website_url: &Feed.website_url(&1[:tree]))
    |> Flow.assign(items: &items/1)
    |> Flow.finish([:url, :title, :description, :website_url, :items])
  end

  defp items(%{tree: tree, url: url}) do
    tree
    |> Feed.items()
    |> Enum.map(fn item -> Scrape.Flow.FeedItem.from_tree(item, url) end)
    |> Enum.filter(fn {status, _} -> status == :ok end)
    |> Enum.map(&elem(&1, 1))
  end
end
