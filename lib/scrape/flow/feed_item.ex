defmodule Scrape.Flow.FeedItem do
  @moduledoc false

  alias Scrape.Flow

  def from_string(string, opts \\ []) do
    Flow.start(%{xml: string, url: nil}, opts)
    |> process_xml()
  end

  defp process_xml(state) do
    state
    # |> Flow.step("Feed.ExtractTitle")
    # |> Flow.step("Feed.ExtractDescription")
    # |> Flow.step("Feed.ExtractWebsiteURL")
    |> Flow.into("FeedItem")
  end
end
