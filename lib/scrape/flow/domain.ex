defmodule Scrape.Flow.Domain do
  @moduledoc false

  alias Scrape.Flow
  alias Scrape.IR.HTML

  def from_url(url, opts \\ []) do
    Flow.start(opts)
    |> Flow.assign(url: url)
    |> Flow.assign(html: &Scrape.Source.HTTP.get!(&1[:url]))
    |> process_html()
  end

  def from_file(path, opts \\ []) do
    Flow.start(opts)
    |> Flow.assign(path: path)
    |> Flow.assign(html: &Scrape.Source.Disk.get!(&1[:path]))
    |> process_html()
  end

  def from_string(html, opts \\ []) do
    Flow.start(opts)
    |> Flow.assign(html: html)
    |> process_html()
  end

  defp process_html(%{assigns: %{html: nil}}), do: {:error, :html_invalid}

  defp process_html(%{assigns: %{html: ""}}), do: {:error, :html_invalid}

  defp process_html(flow) do
    flow
    |> Flow.assign(dom: &Floki.parse(&1[:html]))
    |> Flow.assign(title: &HTML.title(&1[:dom]))
    |> Flow.assign(description: &HTML.description(&1[:dom]))
    |> Flow.assign(icon_url: &HTML.icon_url(&1[:dom], &1[:url]))
    |> Flow.assign(feed_urls: &HTML.feed_urls(&1[:dom], &1[:url]))
    |> Flow.finish([:url, :title, :description, :icon_url, :feed_urls])
  end
end
