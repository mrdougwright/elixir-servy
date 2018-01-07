defmodule PledgeServerTest do
  use ExUnit.Case

  alias Servy.PledgeServer

  test "server caches only 3 most recent pledges and totals amounts" do
    PledgeServer.start()

    PledgeServer.create_pledge("larry", 10)
    PledgeServer.create_pledge("moe", 20)
    PledgeServer.create_pledge("curly", 30)
    PledgeServer.create_pledge("daisy", 40)

    recent_pledges = [{"daisy", 40}, {"curly", 30}, {"moe", 20}]

    assert PledgeServer.recent_pledges() == recent_pledges
    assert PledgeServer.total_pledged() == 90
  end
end
