defmodule Scrape.Flow.Steps.ExtractText do
  @moduledoc false

  def execute(%{html: html}) do
    {:ok, %{text: Scrape.IR.DOM.content(html)}}
  end
end
