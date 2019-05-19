defmodule Scrape.Flow.Steps.ParseXML do
  @moduledoc false

  use Scrape.Flow.Step

  def execute(%{xml: xml}, _) when not is_binary(xml) do
    fail({:xml_error, xml})
  end

  def execute(%{xml: ""}, _) do
    fail({:xml_error, ""})
  end

  def execute(%{xml: xml}, _) when is_binary(xml) do
    assign(tree: Scrape.Tools.Tree.from_xml_string(xml))
  end

  def execute(_, _) do
    fail(:xml_missing)
  end
end
