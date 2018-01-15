defmodule Servy.GenericServer do
   # Helper functions
   def start(module, initial_state, name) do
     pid = spawn(__MODULE__, :listen_loop, [initial_state, module])
     Process.register(pid, name)
     pid
   end

  def call(pid, message) do
    send pid, {:call, self(), message}
    receive do {:response, response} -> response end
  end

  def cast(pid, message) do
    send pid, {:cast, message}
  end

  # Server function
  def listen_loop(state, callback_module) do
    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state} = callback_module.handle_call(message, state)
        send sender, {:response, response}
        listen_loop(new_state, callback_module)
      {:cast, message} ->
        new_state = callback_module.handle_cast(message, state)
        listen_loop(new_state, callback_module)
      other ->
        new_state = callback_module.handle_info(other, state)
        listen_loop(new_state, callback_module)
    end
  end
end

defmodule Servy.PledgeServerHandRolled do

  @name :pledge_server_hand_rolled

  def start do
    IO.puts "Starting the pledge server..."
    Servy.GenericServer.start(__MODULE__, [], @name)
  end

  alias Servy.GenericServer
  # Client interface functions

  def create_pledge(name, amount) do
    GenericServer.call @name, {:create_pledge, name, amount}
  end

  def recent_pledges do
    GenericServer.call @name, :recent_pledges
  end

  def total_pledged do
    GenericServer.call @name, :total_pledged
  end

  def clear do
    GenericServer.cast @name, :clear
  end

  def handle_cast(:clear, _state) do
    []
  end

  def handle_call(:total_pledged, state) do
    total = Enum.map(state, &elem(&1, 1)) |> Enum.sum
    {total, state}
  end

  def handle_call(:recent_pledges, state) do
    {state, state}
  end

  def handle_call({:create_pledge, name, amount}, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state, 2)
    new_state = [ {name, amount} | most_recent_pledges ]
    {id, new_state}
  end

  def handle_info(other, state) do
    IO.puts "Unexpected message: #{inspect other}"
    state
  end

  defp send_pledge_to_service(name, amount) do
    url = "https://httparrot.herokuapp.com/post"
    body = ~s({"name": #{name}, "amount": #{amount}})
    headers = [{"Content-Type", "application/json"}]
    resp = HTTPoison.post url, body, headers
    handle_response(resp)
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    response = Poison.Parser.parse!(body)
    {:ok, response}
  end

  defp handle_response({:error, %{reason: reason}}) do
    {:error, reason}
  end

end

# alias Servy.PledgeServerHandRolled
#
# pid = PledgeServerHandRolled.start()
#
# send pid, {:stop, "hammertime"}
#
# IO.inspect PledgeServerHandRolled.create_pledge("larry", 10)
# IO.inspect PledgeServerHandRolled.create_pledge("moe", 20)
# IO.inspect PledgeServerHandRolled.create_pledge("curly", 30)
# IO.inspect PledgeServerHandRolled.create_pledge("daisy", 40)
#
# # clear cache
# PledgeServerHandRolled.clear()
#
# IO.inspect PledgeServerHandRolled.create_pledge("grace", 50)
#
# IO.inspect PledgeServerHandRolled.recent_pledges()
#
# IO.inspect PledgeServerHandRolled.total_pledged()
#
#
# IO.inspect Process.info(pid, :messages)
