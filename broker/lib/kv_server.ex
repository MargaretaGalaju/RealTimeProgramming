defmodule KVServer do
  require Logger

  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, active: false, reuseaddr: true])
    IO.inspect("Broker is ready to work t")

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
    IO.inspect("Got the socket body")
    IO.inspect(body)

    serve(socket)
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
