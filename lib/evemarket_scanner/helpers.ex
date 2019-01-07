defmodule EvemarketScanner.Helpers do
	def date_to_datetime(date) do
		Timex.parse!(date <> "T00:00:00+00:00" ,"%FT%T%:z", :strftime)
	end

	def cast_date(date) do
		date
			|> Timex.parse!("%FT%TZ", :strftime)
			|> Timex.to_datetime()
	end
end