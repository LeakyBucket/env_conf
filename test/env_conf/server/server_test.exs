defmodule EnvConf.ServerTest do
  use ExUnit.Case

  test "sets default values if given" do
    dict = HashDict.new |> HashDict.put("FIRST", "one") |> HashDict.put("SECOND", "two")
    {:ok, pid} = :gen_server.start_link(EnvConf.Server, dict, [])

    first = :gen_server.call(pid, {:get, "FIRST"})
    second = :gen_server.call(pid, {:get, "SECOND"})

    assert first == "one"
    assert second == "two"
  end

  test "doesn't set default values also present in ENV" do
    :ok = System.put_env("BACON", "good")
    dict = HashDict.new |> HashDict.put("BACON", "bad")
    {:ok, pid} = :gen_server.start_link(EnvConf.Server, dict, [])
    bacon = :gen_server.call(pid, {:get, "BACON"})

    assert bacon != "bad"
  end

  test "starts without defaults" do
    {result, _pid} = :gen_server.start_link(EnvConf.Server, [], [])

    assert result == :ok
  end

  test "returns a value when given {:get, key}" do
    System.put_env("CALL_GET", "true")
    {:ok, pid} = :gen_server.start_link(EnvConf.Server, [], [])
    get = :gen_server.call(pid, {:get, "CALL_GET"})

    assert get == "true"
  end

  test "sets a value when given {:set, key, value}" do
    {:ok, pid} = :gen_server.start_link(EnvConf.Server, [], [])
    :gen_server.call(pid, {:set, "CALL_SET_PAIR", "true"})

    set_pair = System.get_env("CALL_SET_PAIR")

    assert set_pair == "true"
  end

  test "sets multiple values when given {:set, dict}" do
    {:ok, pid} = :gen_server.start_link(EnvConf.Server, [], [])
    dict = HashDict.new |> HashDict.put("CALL_DICT_1", "true") |> HashDict.put("CALL_DICT_2", "true")

    :gen_server.call(pid, {:set, dict})
    dict_1 = System.get_env("CALL_DICT_1")
    dict_2 = System.get_env("CALL_DICT_2")

    assert dict_1 == "true"
    assert dict_2 == "true"
  end

  test "returns the value of the requested key" do
    System.put_env("GET", "true")
    EnvConf.Server.start_link

    get = EnvConf.Server.get("GET")

    assert get == "true"
  end

  test "returns the vale as a number" do
    System.put_env("GET_NUMBER", "100")
    EnvConf.Server.start_link

    env_number = EnvConf.Server.get_number("GET_NUMBER")

    assert env_number == 100
  end

  test "returns the value as an atom" do
    System.put_env("GET_ATOM", "ant")
    EnvConf.Server.start_link

    env_atom = EnvConf.Server.get_atom("GET_ATOM")

    assert env_atom == :ant
  end

  test "returns a value of 'true' as true" do
    System.put_env("GET_BOOLEAN_TRUE", "true")
    EnvConf.Server.start_link

    env_boolean = EnvConf.Server.get_boolean("GET_BOOLEAN_TRUE")

    assert env_boolean == true
  end

  test "returns a value of 'false' as false" do
    System.put_env("GET_BOOLEAN_FALSE", "false")
    EnvConf.Server.start_link

    env_boolean = EnvConf.Server.get_boolean("GET_BOOLEAN_FALSE")

    assert env_boolean == false
  end
end
