defmodule Scrape.Source.HTTP.Charset do
  def from_headers(headers) do
    header =
      headers
      |> Enum.filter(fn {k, _} -> k == "Content-Type" end)
      |> first

    if header do
      {_name, content} = header

      ~r/charset=(ISO-8859-[1-9])/i
      |> Regex.run(content, capture: :all_but_first)
      |> first
    else
      nil
    end
  end

  defp first([h | _]), do: h
  defp first(_), do: nil
end
