defmodule Scrape.IR.FeedItem.Author do
  @moduledoc false

  alias Scrape.IR.Query
  alias Scrape.IR.Text

  @spec execute(String.t() | [any()]) :: String.t()

  def execute(dom) do
    case Query.find(dom, "dc|creator, author name, author", :first) do
      nil -> ""
      string -> Text.clean(string)
    end
  end
end
