defmodule CustomClient do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      %{
        id: Subscriber,
        start: {Subscriber, :start_link, ['rtp-broker', 4040]},
      },
    ]

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
