defmodule EvemarketScanner.Scheduler do
	use GenServer
	import EvemarketScanner

	def start_link(opts) do
		GenServer.start_link(__MODULE__, %{})
	end

	def init(state) do
		handle_info(:work, state)
		{:ok, state}
	end

	def handle_info(:work, state) do
		today = Timex.today |> Timex.format!("%Y-%m-%d", :strftime)
		t = transactions("Alex Prog", today) |> process_transactions
		t = [today, t.buy.n, t.buy.total, t.sell.n, t.sell.total, t.diff]
		EvemarketScanner.Csv.write_csv!("transactions.csv", t)
		schedule()
		{:noreply, state}
	end

	def schedule do
		Process.send_after(self(), :work, 20 * 60 * 1000)
	end
end