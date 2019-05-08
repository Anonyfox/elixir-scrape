defmodule Scrape.Flow.Domain do
  @moduledoc false

  alias Scrape.Flow

  def from_url(url, opts \\ []) do
    Flow.start(%{path: nil, url: url}, opts)
    |> Flow.step("FetchHTML")
    |> process_html()
  end

  def from_file(path, opts \\ []) do
    Flow.start(%{path: path, url: nil}, opts)
    |> Flow.step("FetchHTML")
    |> process_html()
  end

  def from_string(string, opts \\ []) do
    Flow.start(%{html: string, url: nil}, opts)
    |> process_html()
  end

  defp process_html(state) do
    state
    |> Flow.step("ParseHTML")
    |> Flow.step("HTML.ExtractTitle")
    |> Flow.step("HTML.ExtractDescription")
    |> Flow.step("HTML.ExtractIconURL")
    |> Flow.step("HTML.ExtractFeedURLs")
    |> Flow.into("Domain")
  end
end
