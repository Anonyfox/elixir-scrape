defmodule Scrape.Flow.Steps.ExtractDescription do
  @moduledoc false

  def execute(assigns), do: execute(assigns, Scrape.Options.merge())

  def execute(assigns, _) when not is_map(assigns) do
    {:error, :no_assigns_given}
  end

  def execute(%{dom: dom}, _) when not is_list(dom) and not is_tuple(dom) do
    {:error, :dom_invalid}
  end

  def execute(%{dom: dom}, _) do
    case Scrape.IR.DOM.description(dom) do
      "" -> {:ok, %{description: nil}}
      description -> {:ok, %{description: description}}
    end
  end

  def execute(_, _) do
    {:error, :dom_missing}
  end
end
