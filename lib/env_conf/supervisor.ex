defmodule EnvConf.Supervisor do
  use Supervisor

  def start_link(defaults \\ []) do
    :supervisor.start_link(__MODULE__, defaults)
  end

  def init(defaults) do
    children = [
      worker(EnvConf.Server, [defaults])
    ]

    # See http://elixir-lang.org/docs/stable/Supervisor.Behaviour.html
    # for other strategies and supported options
    supervise(children, strategy: :one_for_one)
  end
end
