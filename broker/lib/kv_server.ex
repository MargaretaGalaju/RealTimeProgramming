defmodule KVServer do
  require Logger

  def init(arg) do
    {:ok, arg}
  end

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, active: false, reuseaddr: true])
    IO.inspect("Broker is ready to work -----")
    GenServer.start_link(__MODULE__, %{subscribtionStatus: false}, name: __MODULE__)

    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    serve(client)
    loop_acceptor(socket)
  end

  def serve(:error, _) do

  end

  def serve(body, socket) do
    # IO.inspect(state)
    # IO.inspect(body)

    if (body =~ "subscribeTweets") do
      IO.inspect(body) 
      GenServer.cast(__MODULE__, {:subscribe_to_tweets, body})
      end
    if (body =~ "unsubscribeTweets") do 
        IO.inspect(body) 

        GenServer.cast(__MODULE__, {:unsubscribe, body})
      else 
        GenServer.cast(__MODULE__, {:receive_tweets, body})
    end

    serve(socket)
  end

  def handle_cast({:subscribe_to_tweets, data}, state) do
    state = true;

    {:noreply, state}
  end

   def handle_cast({:unsubscribe, data}, state) do
    state = false;

    {:noreply, state}
  end

  def handle_cast({:receive_tweets, data}, state) do
    if state === true do
      IO.inspect(data)
    end

    {:noreply, state}
  end

  def serve(socket) do
    body =  try do
      {:ok, body} = :gen_tcp.recv(socket, 0)
      body
    rescue
      _ -> :error
    end
    serve(body, socket)
  end
end
