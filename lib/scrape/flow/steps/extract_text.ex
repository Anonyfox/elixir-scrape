defmodule Scrape.Flow.Steps.ExtractText do
  @moduledoc false

  def execute(state) when not is_map(state) do
    {:error, :no_state_given}
  end

  def execute(%{html: html}) when not is_binary(html) do
    {:error, :html_invalid}
  end

  def execute(%{html: html}) do
    {:ok, %{text: Scrape.IR.DOM.content(html)}}
  end

  def execute(_state) do
    {:error, :html_missing}
  end
end
