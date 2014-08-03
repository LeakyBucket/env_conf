defmodule EnvConf do
  use Application

  # See http://elixir-lang.org/docs/stable/Application.Behaviour.html
  # for more information on OTP Applications
  def start(_type, args \\ []) do
    EnvConf.Supervisor.start_link(args)
  end
end
