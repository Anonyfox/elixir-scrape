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
    |> Flow.assign(xml: &Scrape.Source.Disk.get!(&1[:path]))
    |> process_xml()
  end

  def from_string(xml, opts \\ []) do
    Flow.start(opts)
    |> Flow.assign(xml: xml)
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
    |> Flow.finish([:url, :title, :description, :website_url])
  end
end
