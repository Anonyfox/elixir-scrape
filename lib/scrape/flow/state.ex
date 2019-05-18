defmodule Scrape.Flow.State do
  defstruct halted: nil, error: nil, assigns: %{}, opts: []

  def new(assigns \\ %{}, opts \\ []) do
    %__MODULE__{assigns: assigns, opts: Scrape.Options.merge(opts)}
  end

  def assign(%__MODULE__{} = state, key, fun) when is_function(fun) do
    assign(state, key, fun.(state.assigns, state.opts))
  end

  def assign(%__MODULE__{} = state, key, value) do
    put_in(state, [:assigns, key], value)
  end

  def assign_to(value, key, %__MODULE__{} = state) do
    put_in(state, [:assigns, key], value)
  end

  def reject(%__MODULE__{} = state, reason) do
    %{state | halted: true, error: reason}
  end

  def fetch(%__MODULE__{} = state, key) do
    get_in(state, [:assigns, key])
  end

  def opt(%__MODULE__{} = state, key) do
    Keyword.get(state.opts, key)
  end
end
