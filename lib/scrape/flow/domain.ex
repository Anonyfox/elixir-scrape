defmodule Scrape.Flow.Domain do
  @moduledoc false

  alias Scrape.Flow

  def from_url(url) do
    Flow.start(%{path: nil, url: url})
    |> Flow.step(:FetchHTML)
    |> process_html()
  end

  def from_file(path) do
    Flow.start(%{path: path, url: nil})
    |> Flow.step(:FetchHTML)
    |> process_html()
  end

  def from_string(string) do
    Flow.start(%{html: string, url: nil})
    |> process_html()
  end

  defp process_html(state) do
    state
    |> Flow.step(:ParseHTML)
    |> Flow.step(:ExtractTitle)
    |> Flow.step(:ExtractDescription)
    |> Flow.step(:ExtractIconURL)
    |> Flow.step(:ExtractFeedURLs)
    |> Flow.stop([:url, :title, :description, :icon_url, :feed_urls])
  end
end
