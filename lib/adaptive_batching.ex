defmodule AdaptiveBatching do
  use GenServer
  
  def start_link(message) do
      GenServer.start(__MODULE__, message, name: __MODULE__)
  end
  
  def init(_state) do
      {:ok, []}
  end

  def insert(tweet) do
      GenServer.cast(__MODULE__, {:insert, tweet})
  end

  def handle_cast({:insert, tweet}, state) do
      tweets = state ++ [tweet];

      if Enum.count(tweets) >= 128 do
        GenServer.cast(__MODULE__, :add_tweets_in_database)
      end

      {:noreply, tweets}
  end

  @impl true
  def handle_cast(:add_tweets_in_database, tweets) do
    spawn(fn ->
      Enum.each(tweets, fn tweet ->
        add_tweets_in_database(tweet)
      end)
    end)
    {:noreply, []}
  end

  def add_tweets_in_database(message) do
    {:ok, pid} = Mongo.start_link(url: "mongodb://mongodb:27017/rtp");
    IO.inspect(message)
    Mongo.insert_one!(pid, "user", message)
  end
end