defmodule Scrape.Flow.Steps.ExtractDescription do
  @moduledoc false

  def execute(state) when not is_map(state) do
    {:error, :no_state_given}
  end

  def execute(%{dom: dom}) when not is_list(dom) and not is_tuple(dom) do
    {:error, :dom_invalid}
  end

  def execute(%{dom: dom}) do
    case Scrape.IR.DOM.description(dom) do
      "" -> {:ok, %{description: nil}}
      description -> {:ok, %{description: description}}
    end
  end

  def execute(_map) do
    {:error, :dom_missing}
  end
end
