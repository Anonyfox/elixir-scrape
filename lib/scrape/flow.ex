defmodule Scrape.Flow do
  defstruct halted: nil, error: nil, assigns: %{}, opts: []

  def start(assigns \\ %{}, opts \\ []) do
    %__MODULE__{assigns: assigns, opts: Scrape.Options.merge(opts)}
  end

  def step(%{halted: true} = state, _), do: state

  def step(%{assigns: assigns, opts: opts} = state, step_name) do
    case apply(Module.concat([__MODULE__, "Steps", step_name]), :execute, [assigns, opts]) do
      {:ok, data} -> %{state | assigns: Map.merge(assigns, data)}
      {:error, reason} -> Map.merge(state, %{halted: true, error: reason})
    end
  end

  def into(%{halted: true, error: reason}, _), do: {:error, reason}

  def into(%{assigns: assigns} = _state, target_name) do
    module = Module.concat([Scrape.Target, target_name])
    {:ok, apply(module, :build, [assigns])}
  end
end
