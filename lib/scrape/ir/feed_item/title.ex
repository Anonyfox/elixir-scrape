defmodule Scrape.IR.FeedItem.Title do
  @moduledoc false

  alias Scrape.IR.Query
  alias Scrape.IR.Text

  @spec execute(String.t() | [any()]) :: String.t()

  def execute(dom) do
    Query.find(dom, "title", :first) |> Text.clean()
  end
end
