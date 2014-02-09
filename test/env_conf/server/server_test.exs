defmodule EnvConf.ServerTest do
  use Amrita.Sweet

  describe "init" do
    it "sets default values if given" do
      dict = HashDict.new [{"FIRST", "one"}, {"SECOND", "two"}]
      {:ok, pid} = :gen_server.start_link(EnvConf.Server, dict, [])

      :gen_server.call(pid, {:get, "FIRST"}) |> equals "one"
      :gen_server.call(pid, {:get, "SECOND"}) |> equals "two"
    end

    it "doesn't set default values also present in ENV" do
      :ok = System.put_env("BACON", "good")
      dict = HashDict.new [{"BACON", "bad"}]
      {:ok, pid} = :gen_server.start_link(EnvConf.Server, dict, [])

      :gen_server.call(pid, {:get, "BACON"}) |> !equals "bad"
    end

    it "starts without defaults" do
      {result, pid} = :gen_server.start_link(EnvConf.Server, [], [])

      result |> equals :ok
    end
  end

  describe "handle_call" do
    it "returns a value when given {:get, key}" do
      System.put_env("CALL_GET", "true")
      {:ok, pid} = :gen_server.start_link(EnvConf.Server, [], [])

      :gen_server.call(pid, {:get, "CALL_GET"}) |> equals "true"
    end

    it "sets a value when given {:set, key, value}" do
      {:ok, pid} = :gen_server.start_link(EnvConf.Server, [], [])
      :gen_server.call(pid, {:set, "CALL_SET_PAIR", "true"})

      System.get_env("CALL_SET_PAIR") |> equals "true"
    end

    it "sets multiple values when given {:set, dict}" do
      {:ok, pid} = :gen_server.start_link(EnvConf.Server, [], [])
      dict = HashDict.new [{"CALL_DICT_1", "true"}, {"CALL_DICT_2", "true"}]

      :gen_server.call(pid, {:set, dict})

      System.get_env("CALL_DICT_1") |> equals "true"
      System.get_env("CALL_DICT_2") |> equals "true"
    end
  end

  describe "handle_info" do
    it "updates the env when given {:set, key, value}" do
      {:ok, pid} = :gen_server.start_link(EnvConf.Server, [], [])
      
      send(pid, {:set, "INFO_SET", "true"})

      System.get_env("INFO_SET") |> equals "true"
    end

    it "updates the env when given {:set, dict}" do
      {:ok, pid} = :gen_server.start_link(EnvConf.Server, [], [])
      dict = HashDict.new [{"INFO_DICT_1", "true"}, {"INFO_DICT_2", "true"}]
      
      send(pid, {:set, dict})

      System.get_env("INFO_DICT_1") |> equals "true"
      System.get_env("INDO_DICT_2") |> equals "true"
    end
  end
end