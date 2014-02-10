# EnvConf

A simple config service for Elixir.

EnvConf uses the system environment for configuration values.  EnvConf always look to the system environment for configuration values.  It is possible to set values through this service.  Any value you set is written to the system environment.  It is also possible to specify default values when starting the service.  Defaults will only be set if they are not already present in the system environment.  

```
  EnvConf.start([])

  # Default options can be passed to the Supervisor start_link call as a HashDict
  EnvConf.start([], default_dict)

  EnvConf.Server.get("TERM")
  > "vt100"

  EnvConf.Server.get_atom("ATOM")
  > :atom

  EnvConf.Server.get_number("TWELVE")
  > 12

  EnvConf.Server.get_boolean("TRUE")
  > true
```