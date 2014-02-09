defmodule EnvConf.Server do
  @moduledoc """
    The EnvConf Server is the main config service.  It provides a few functions for getting and setting Config Values.  

    The current behavior for setting values requires that both the key and value be binaries.  However there are get functions that will return a value of a specific type.  
  """

  use GenServer.Behaviour

  def start_link(defaults \\ []) do
    :gen_server.start_link({:local, :env_conf}, __MODULE__, defaults, [])
  end

  @doc """
    get takes a binary key value.  It returns the binary stored in the system environment at that key.
  """
  def get(key) do
    :gen_server.call :env_conf, {:get, key}
  end

  @doc """
    get_number takes a binary key value.  It returns the result of calling Kernel.binary_to_integer on the binary stored in the system environment at that key.
  """
  def get_number(key) do
    val = get(key)

    binary_to_integer(val)
  end

  @doc """
    get_atom takes a binary key value.  It returns the result of calling Kernel.binary_to_atom on the binary stored in the system environment at the given key.
  """
  def get_atom(key) do
    val = get(key)

    binary_to_atom(val)
  end

  @doc """
    get_boolean takes a binary key value.  If the value of that environment key is "false" or "FALSE" then it returns false.  If the value of that environment key is "true" or "TRUE" then it returns true.
  """
  def get_boolean(key) do
    case get(key) do
      "false" -> false
      "FALSE" -> false
      "true" -> true
      "TRUE" -> true
    end
  end
  
  @doc """
    Set the environment variable specified by key to the binary version of value.
  """
  def set(key, value) do # TODO: convert value types to binary (guard clauses)
    :gen_server.call :env_conf, {:set, key, value}
  end

  @doc """
    Translate the given HashDict to the system environment.  Keys map to environment variables and values map to values.
  """
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


  defp set_if_missing(dict) do
    Enum.each dict, fn({key, value}) ->
                      to_set = (System.get_env(key) || value)
                      System.put_env(key, to_set)
                    end
  end
end