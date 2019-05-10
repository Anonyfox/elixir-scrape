defmodule Scrape.Flow.Feed do
  @moduledoc false

  alias Scrape.Flow

  def from_url(url, opts \\ []) do
    Flow.start(%{path: nil, url: url}, opts)
    |> Flow.step("FetchDocument")
    |> process_xml()
  end

  def from_string(string, opts \\ []) do
    Flow.start(%{xml: string, url: nil}, opts)
    |> process_xml()
  end

  defp process_xml(state) do
    state
    |> Flow.step("ParseXML")
    |> Flow.step("Feed.ExtractTitle")
    |> Flow.step("Feed.ExtractDescription")
    |> Flow.step("Feed.ExtractWebsiteURL")
    |> Flow.into("Feed")
  end
end
