defmodule Scrape.Flow.Steps.ExtractBodyTest do
  use ExUnit.Case

  alias Scrape.Flow.Steps.ExtractBody

  test "refuses if no state is given" do
    assert ExtractBody.execute(nil) == {:error, :no_state_given}
  end

  test "refuses if html not existing in state" do
    assert ExtractBody.execute(%{}) == {:error, :html_missing}
  end

  test "refuses if html is nil" do
    assert ExtractBody.execute(%{html: nil}) == {:error, :html_invalid}
  end

  test "works if non-empty html string is given" do
    html = "cache/article/nytimes.html" |> File.read!()
    {:ok, %{body: body}} = ExtractBody.execute(%{html: html})
    assert body =~ "their own minimum wages"
  end

  test "transforms empty body to nil if nothing is found" do
    html = "<html><body /></html>"
    assert ExtractBody.execute(%{html: html}) == {:ok, %{body: nil}}
  end
end
