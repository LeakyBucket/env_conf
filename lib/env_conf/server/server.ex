defmodule EnvConf.Server do
  use GenServer.Behaviour

  def start_link(defaults) do
    :gen_server.start_link({:local, :env_conf}, __MODULE__, defaults, [])
  end

  def get(key) do
    :gen_server.call :env_conf, {:get, key}
  end

  def set(key, value) do
    :gen_server.call :env_conf, {:set, key, value}
  end

  def set(dict) do
    :gen_server.call :env_conf, {:set, dict}
  end
  

  def init(defaults) do
    { set_if_missing(defaults), nil }
  end
  
  def handle_call({:get, key}, _from, state) do
    { :reply, System.get_env(key), state }
  end
  def handle_call({:set, key, value}, _from, state) do
    { :reply, System.put_env(key, value), state }
  end
  def handle_call({:set, dict}, _from, state) do
    { :reply, System.put_env(dict), state}
  end
  
  def handle_info({:set, key, value}, state) do
    :ok = System.put_env(key, value)

    { :noreply, state }
  end
  def handle_info({:set, dict}, state) do
    :ok = System.put_env(dict)

    { :noreply, state}
  end

  defp set_if_missing(dict) do
    Enum.each dict, fn({key, value}) ->
                      to_set = (System.get_env(key) || value)
                      System.put_env(key, to_set)
                    end
  end
end