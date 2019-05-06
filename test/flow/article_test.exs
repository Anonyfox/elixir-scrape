defmodule Scrape.Flow.ArticleTest do
  use ExUnit.Case

  alias Scrape.Flow.Article

  describe "Article#from_url" do
  end

  describe "Article#from_file" do
    test "works when a valid article file exists" do
      {:ok, data} = Article.from_file("cache/article/nytimes.html")
      assert data.title =~ "Highest Minimum Wage"
      assert data.summary =~ "raising the minimum wage"
    end

    test "refuses when no file exists" do
      {:error, error} = Article.from_file("missing")
      assert error == {:disk_error, :enoent}
    end
  end

  describe "Article#from_string" do
    test "works when a valid string is given" do
      html = File.read!("cache/article/nytimes.html")
      {:ok, data} = Article.from_string(html)
      assert data.title =~ "Highest Minimum Wage"
      assert data.summary =~ "raising the minimum wage"
    end

    test "refuses when nil is given" do
      {:error, error} = Article.from_string(nil)
      assert error == {:html_error, nil}
    end

    test "refuses when empty string is given" do
      {:error, error} = Article.from_string("")
      assert error == {:html_error, ""}
    end
  end
end
