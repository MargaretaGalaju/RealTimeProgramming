require Logger

defmodule Root do
  def recv do
    receive do
      {:data, msg} -> msg_operations(msg)
    end
  end

  d+ef msg_operations(msg) do
    calculate_sentiments(msg)
    recv()
  end

  def calculate_sentiments(data) do
    user_words_array = data["text"]
    |> String.split(" ", trim: true)

    scores_array = Enum.map(user_words_array, fn word -> EmotionValues.get_value(word) end)
    final_score = Enum.sum(scores_array)

    IO.puts(final_score)
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :recv, [opts]},
      type: :worker,
      restart: :permanent,
    }
  end
end
