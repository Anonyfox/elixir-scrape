defmodule Scrape.Flow.Steps.ExtractTitle do
  @moduledoc false

  def execute(state) when not is_map(state) do
    {:error, :no_state_given}
  end

  def execute(%{dom: dom}) when not is_list(dom) and not is_tuple(dom) do
    {:error, :dom_invalid}
  end

  def execute(%{dom: dom}) do
    case Scrape.IR.DOM.title(dom) do
      "" -> {:ok, %{title: nil}}
      title -> {:ok, %{title: title}}
    end
  end

  def execute(_map) do
    {:error, :dom_missing}
  end
end
