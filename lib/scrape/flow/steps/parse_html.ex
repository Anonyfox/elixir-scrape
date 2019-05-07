defmodule Scrape.Flow.Steps.ParseHTML do
  @moduledoc false

  use Scrape.Flow.Step

  def execute(%{html: html}, _) when not is_binary(html) do
    fail({:html_error, html})
  end

  def execute(%{html: ""}, _) do
    fail({:html_error, ""})
  end

  def execute(%{html: html}, _) when is_binary(html) do
    assign(dom: Floki.parse(html))
  end

  def execute(_, _) do
    fail(:html_missing)
  end
end
