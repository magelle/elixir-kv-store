defmodule KV.Registry do
    use GenServer

    ## Client API

    @doc """
    Starts the registry
    """
    def start_link(opts) do
        GenServer.start_link(__MODULE__, :ok, opts) ## __MODULE__ eans current module
    end

    @doc """
    Looks up th bucket pid for `name` stored in `server`.

    Return `{:ok, pid}` if the bucket exists, `:error` otherwise.
    """
    def lookup(server, name) do
        GenServer.call(server, {:lookup, name})
    end

    @doc """
    Ensures there is a bucket associated with the given `name` in `server`.
    """
    def create(server, name) do
        GenServer.cast(server, {:create, name})
    end

    ## Server Callbacks

    def init(:ok) do
        {:ok, %{}}
    end

    def handle_call({:lookup, name}, _from, names) do
        {:reply, Map.fetch(names, name), names}
    end

    def handle_cast({:create, name}, names) do
        if Map.has_key?(names, name) do
            {:noreply, names}
        else
            {:ok, bucket} = KV.Bucket.start_link([])
            {:noreply, Map.put(names, name, bucket)}
        end
    end

end