defmodule Servy.PledgeServer do

  @name :pledge_server

  use GenServer #, restart: :temporary # <- to override one

  defmodule State do
    defstruct cache_size: 3, pledges: []
  end

  # full override, to customize GenServer function(s)
  def child_spec(arg) do
    %{id: __MODULE__, restart: :temporary, shutdown: 4000,
      start: {__MODULE__, :start_link, [[]]}, type: :worker}
  end

  # Client interface functions

  def start_link(_arg) do
    IO.puts "Starting the pledge server..."
    # %State{} gets passed to init function below, by GenServer
    HTTPoison.start
    GenServer.start_link(__MODULE__, %State{}, name: @name)
  end

  def create_pledge(name, amount) do
    GenServer.call @name, {:create_pledge, name, amount}
  end

  def recent_pledges do
    GenServer.call @name, :recent_pledges
  end

  def total_pledged do
    GenServer.call @name, :total_pledged
  end

  def clear do
    GenServer.cast @name, :clear
  end

  def set_cache_size(size) do
    GenServer.cast @name, {:set_cache_size, size}
  end

  # Server Callbacks

  def init(state) do
    pledges = fetch_recent_pledges_from_service()
    new_state = %{ state | pledges: pledges }
    {:ok, new_state}
  end

  def handle_cast(:clear, state) do
    {:noreply, %{ state | pledges: []}}
  end

  def handle_cast({:set_cache_size, size}, state) do
    resized_cache = Enum.take(state.pledges, size)
    new_state = %{ state | cache_size: size, pledges: resized_cache }
    {:noreply, new_state}
  end

  def handle_call(:total_pledged, _from, state) do
    total = Enum.map(state.pledges, &elem(&1, 1)) |> Enum.sum
    {:reply, total, state}
  end

  def handle_call(:recent_pledges, _from, state) do
    {:reply, state.pledges, state}
  end

  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state.pledges, state.cache_size - 1)
    cached_pledges = [ {name, amount} | most_recent_pledges ]
    new_state = %{state | pledges: cached_pledges}
    {:reply, id, new_state}
  end

  def handle_info(message, state) do
    IO.puts "Can't touch this! #{inspect message}"
    {:noreply, state}
  end

  defp send_pledge_to_service(name, amount) do
    url = "https://httparrot.herokuapp.com/post"
    body = ~s({"name": #{name}, "amount": #{amount}})
    headers = [{"Content-Type", "application/json"}]
    resp = HTTPoison.post url, body, headers
    handle_response(resp)
    # {:ok, "pledge-#{:rand.uniform(1000)}"} # stubbed response
  end

  defp fetch_recent_pledges_from_service do
    # CODE GOES HERE TO FETCH RECENT PLEDGES FROM EXTERNAL SERVICE
    [ {"wilma", 15}, {"fred", 25} ]
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    response = Poison.Parser.parse!(body)
    {:ok, response}
  end

  defp handle_response({:error, %{reason: reason}}) do
    {:error, reason}
  end

end

alias Servy.PledgeServer

# {:ok, pid} = PledgeServer.start() # now calls GenServer start
#
# send pid, {:stop, "hammertime"}
#
# PledgeServer.set_cache_size(4)
#
# IO.inspect PledgeServer.create_pledge("larry", 10)
# # clear cache
# PledgeServer.clear()
#
# IO.inspect PledgeServer.create_pledge("moe", 20)
# IO.inspect PledgeServer.create_pledge("curly", 30)
# IO.inspect PledgeServer.create_pledge("daisy", 40)
#
#
# IO.inspect PledgeServer.create_pledge("grace", 50)
#
# IO.inspect PledgeServer.recent_pledges()
#
# IO.inspect PledgeServer.total_pledged()
#
# :sys.get_state(pid)
# IO.inspect Process.info(pid, :messages)
