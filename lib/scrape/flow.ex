defmodule Scrape.Flow do
  defstruct(state: %{halted: false, error: nil}, assigns: %{}, options: [])

  def fetch(_url), do: "<html></html>"

  def start(assigns \\ [], opts \\ []) do
    %__MODULE__{assigns: Enum.into(assigns, %{}), options: opts}
  end

  def assign(%__MODULE__{state: %{halted: true}} = flow, _) do
    flow
  end

  def assign(%__MODULE__{} = flow, [{k, v}]) when not is_function(v) do
    %{flow | assigns: Map.put(flow.assigns, k, v)}
  end

  def assign(%__MODULE__{} = flow, [{k, v}]) do
    try do
      %{flow | assigns: Map.put(flow.assigns, k, v.(flow.assigns))}
    rescue
      error -> %{flow | state: %{halted: true, error: {:assign, k, error}}}
    end
  end

  def finish(_flow, keys \\ [])

  def finish(%__MODULE__{state: %{halted: true, error: error}}, _) do
    {:error, error}
  end

  def finish(%__MODULE__{assigns: assigns}, []), do: {:ok, assigns}

  def finish(%__MODULE__{assigns: assigns}, keys) do
    {:ok, Map.take(assigns, keys)}
  end
end
