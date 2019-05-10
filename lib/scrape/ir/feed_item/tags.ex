defmodule Scrape.IR.FeedItem.Tags do
  @moduledoc false

  alias Scrape.IR.Query
  alias Scrape.IR.Text

  @spec execute(String.t() | [any()]) :: [String.t()]

  def execute(dom) do
    Query.find(dom, "category", :all)
    |> Enum.map(&Text.clean/1)
    |> Enum.map(&String.downcase/1)
  end
end
