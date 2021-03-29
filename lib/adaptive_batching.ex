defmodule AdaptiveBatching do
    use GenServer
  
    @impl true
    def init(_arg) do
      data = []
      {:ok, data}
    end
  
    def start_link(_arg) do
      GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
    end
  
    def insert(element) do
      GenServer.cast(AdaptiveBatching, {:insert, element})
    end
  
    @impl true
    def handle_cast({:insert, element}, q) do
      elements = [element | q]
      if Enum.count(elements) >= 128 do
        GenServer.cast(__MODULE__, :batch)
      end
  
      {:noreply, elements}
    end
  
    @impl true
    def handle_cast(:batch, q) do
      spawn(fn ->
        Enum.each(q, fn element ->
        #   IO.put(element)
        end)
      end)
      {:noreply, []}
    end
  end