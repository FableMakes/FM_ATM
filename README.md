# FM ATM Robbery (v8 Ultimate)

A fully modular ATM robbery system for FiveM.

## Features

* Framework agnostic (Qbox / QB / ESX)
* Inventory agnostic (ox / qb / qs / esx)
* Dispatch support (tk / ps / cd / qs)
* Target support (ox_target / qb-target)
* PinCracker minigame
* Per-ATM cooldowns
* Config-driven system
* Hook system for easy extensions

## Installation

1. Place `fm_atm` in your resources folder
2. Add to server.cfg:

   ```
   ensure fm_atm
   ```
3. Configure `config.lua`

## Requirements

* ox_lib
* bd-minigames
* (optional) dispatch system
* (optional) target system
* (optional) inventory system

## Configuration

All settings are inside:

```
config.lua
```

## License

Free to use and modify, just do not use for profit.

