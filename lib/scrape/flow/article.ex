defmodule Scrape.Flow.Article do
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
    |> Flow.step(:ExtractImageURL)
    |> Flow.step(:ExtractText)
    |> Flow.step(:DetectLanguage)
    |> Flow.step(:CalculateStems)
    |> Flow.step(:CalculateSummary)
    |> Flow.into(:Article)
  end
end
