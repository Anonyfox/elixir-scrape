defmodule Scrape.Flow.Steps.ExtractIconURL do
  @moduledoc false

  def execute(assigns) when not is_map(assigns) do
    {:error, :no_assigns_given}
  end

  def execute(%{dom: dom}) when not is_list(dom) and not is_tuple(dom) do
    {:error, :dom_invalid}
  end

  def execute(%{dom: dom, url: url}) do
    {:ok, %{icon_url: Scrape.IR.DOM.icon_url(dom, url)}}
  end

  def execute(%{dom: dom}) do
    {:ok, %{icon_url: Scrape.IR.DOM.icon_url(dom)}}
  end

  def execute(_) do
    {:error, :dom_missing}
  end
end
