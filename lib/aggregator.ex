defmodule Aggregator do
    use GenServer

    def start_link() do
        IO.puts("starting aggregator")
        GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
    end

    @impl true
    def init(_state) do
        {:ok, %{tweets: %{}}}
    end

    def add_engagement(score) do
        GenServer.cast(__MODULE__, {:engagement, {score}})
    end
        
    def handle_cast({:engagement, score}, state) do
        tweets = put_in_map("engagement", score, state)
        {:noreply, %{tweets: tweets}}
    end

    def put_in_map(data_type, value, state) do
    #   put in map the tweets, compare by id
    IO.puts(state)
    #    AdaptiveBatching.insert(message)
    end
end