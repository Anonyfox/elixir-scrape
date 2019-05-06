defmodule Scrape.Flow do
  def start(attrs \\ %{}) do
    Map.merge(attrs, %{error: nil, halted: nil})
  end

  def step(%{halted: true} = state, _), do: state

  def step(state, step_name) do
    case apply(Module.concat([__MODULE__, "Steps", step_name]), :execute, [state]) do
      {:ok, data} -> Map.merge(state, data)
      {:error, reason} -> Map.merge(state, %{halted: true, error: reason})
    end
  end

  def stop(%{halted: true, error: reason}, _), do: {:error, reason}

  def stop(state, keys) do
    {:ok, Map.take(state, keys)}
  end
end
