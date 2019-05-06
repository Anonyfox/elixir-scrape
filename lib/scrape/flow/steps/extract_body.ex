defmodule Scrape.Flow.Steps.ExtractBody do
  @moduledoc false

  def execute(%{html: html}) do
    {:ok, %{body: html |> Scrape.IR.DOM.paragraphs() |> Enum.join(".\n\n")}}
  end
end
