defmodule Scrape.Flow.Step do
  defmacro assign(data) do
    quote do
      {:ok, Enum.into(unquote(data), %{})}
    end
  end

  defmacro fail(reason) do
    quote do
      {:error, unquote(reason)}
    end
  end

  defmacro __using__(_) do
    quote do
      import Scrape.Flow.Step

      def execute(assigns), do: execute(assigns, Scrape.Options.merge())

      def execute(assigns, _) when not is_map(assigns) do
        fail(:no_assigns_given)
      end
    end
  end
end
