defmodule Scrape.IR.FeedItem.Description do
  @moduledoc false

  alias Scrape.IR.Query
  alias Scrape.IR.Text

  @spec execute(String.t() | [any()]) :: String.t()

  def execute(dom) do
    Query.find(dom, "description, summary, content", :first) |> Text.clean()
  end
end
