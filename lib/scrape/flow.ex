defmodule Scrape.Flow do
  @moduledoc """
  Logic Module for implementing linear data processing workflows.

  Uses a "token" approach to store/retrieve values and persists a pipeline
  state that can be halted at any time. In case that something goes wrong,
  the pipeline will be halted and an error object will be returned with the
  occured error. Therefore, the pipeline should never raise an actual exception.
  """

  @typedoc """
  Intermediate state object that holds everything relevant for the data
  processing work flow. `state` holds general processing information, `assigns`
  are the user-level data fields and `options` contains a keyword list for,
  well, configuration options.
  """

  @type flow :: %__MODULE__{
          state: %{
            halted: boolean(),
            error: nil | any()
          },
          assigns: map(),
          options: [{atom(), any()}]
        }

  defstruct(state: %{halted: false, error: nil}, assigns: %{}, options: [])

  @doc """
  Initiate a new data processing flow with optional configuration.

  NOTE: the options are currently not used but will be in upcoming versions.

  ## Example
          iex> Flow.start()
          %Flow{state: %{halted: false, error: nil}, assigns: %{}, options: []}
  """

  @spec start([{atom(), any()}]) :: flow

  def start(opts \\ []) do
    %__MODULE__{options: opts}
  end

  @doc """
  Declare a new value in the data flow.

  Will do nothing if the flow got halted previously. If a function is given,
  and it raises an exception, the pipeline will catch the error and transform
  into a halted state.
  """

  @spec assign(flow, [{atom(), any()}]) :: flow

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

  @doc """
  Select keys from the flow assigns and return a map with the chosen fields.

  Will result in an error object if the flow got halted previously.
  """

  @spec finish(flow, [atom()]) :: {:ok, map()} | {:error, any()}

  def finish(_flow, keys \\ [])

  def finish(%__MODULE__{state: %{halted: true, error: error}}, _) do
    {:error, error}
  end

  def finish(%__MODULE__{assigns: assigns}, []), do: {:ok, assigns}

  def finish(%__MODULE__{assigns: assigns}, keys) do
    {:ok, Map.take(assigns, keys)}
  end
end
