defmodule Scrape.Flow.Article do
  @moduledoc false

  alias Scrape.Flow

  def from_url(url, opts \\ []) do
    Flow.start(%{path: nil, url: url}, opts)
    |> Flow.step(:FetchHTML)
    |> process_html()
  end

  def from_file(path, opts \\ []) do
    Flow.start(%{path: path, url: nil}, opts)
    |> Flow.step(:FetchHTML)
    |> process_html()
  end

  def from_string(string, opts \\ []) do
    Flow.start(%{html: string, url: nil}, opts)
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
