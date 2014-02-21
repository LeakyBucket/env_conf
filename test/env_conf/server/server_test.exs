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
      {result, _pid} = :gen_server.start_link(EnvConf.Server, [], [])

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

  describe "get" do
    it "returns the value of the requested key" do
      System.put_env("GET", "true")
      EnvConf.Server.start_link

      EnvConf.Server.get("GET") |> equals "true"
    end
  end

  describe "get_number" do
    it "returns the vale as a number" do
      System.put_env("GET_NUMBER", "100")
      EnvConf.Server.start_link

      EnvConf.Server.get_number("GET_NUMBER") |> equals 100
    end
  end

  describe "get_atom" do
    it "returns the value as an atom" do
      System.put_env("GET_ATOM", "ant")
      EnvConf.Server.start_link

      EnvConf.Server.get_atom("GET_ATOM") |> equals :ant
    end
  end

  describe "get_boolean" do
    it "returns a value of 'true' as true" do
      System.put_env("GET_BOOLEAN_TRUE", "true")
      EnvConf.Server.start_link

      EnvConf.Server.get_boolean("GET_BOOLEAN_TRUE") |> equals true
    end

    it "returns a value of 'false' as false" do
      System.put_env("GET_BOOLEAN_FALSE", "false")
      EnvConf.Server.start_link

      EnvConf.Server.get_boolean("GET_BOOLEAN_FALSE") |> equals false
    end
  end
end