defmodule Scrape.Flow.Steps.ExtractTitle do
  @moduledoc false

  def execute(%{dom: dom}) do
    {:ok, %{title: Scrape.IR.DOM.title(dom)}}
  end
end
