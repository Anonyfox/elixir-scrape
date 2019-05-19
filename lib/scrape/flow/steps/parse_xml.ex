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
    # map =
    #   xml
    #   # remove xml inconsistencies
    #   |> Floki.parse()
    #   |> Floki.raw_html()
    #   # remove the intro with encoding attribute, fetching normalizes to UTF-8
    #   |> String.replace(~r/<\?xml.*?>/i, "")
    #   # transform into map
    #   |> XmlToMap.naive_map()

    # assign(map: map, dom: Floki.parse(xml))
    assign(dom: Floki.parse(xml))
  end

  def execute(_, _) do
    fail(:xml_missing)
  end
end
