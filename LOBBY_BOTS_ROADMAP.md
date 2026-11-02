# IW3 host-local public lobby bot prototype

## Current prototype scope

- Runs only for the local host while the online public game lobby is active (`onlinegame`, `onlinegameandhost`, and `inlobby` are true; `xblive_privatematch` is false). The `inlobby` check keeps this out of the party-host screen/state.
- Shows a host-local overlay with simulated bot names, arrivals/departures, and simulated map-veto vote totals. These simulated lobby bots are not Xbox Live session members, are not replicated to other players, and their displayed votes do not alter the real party veto state.
- Simulated arrivals use a randomized interval interpolated from 5–30 seconds at one lobby occupant to 0.33–2.5 seconds at eight or more occupants. Every two seconds there is a 10% chance that one or two simulated bots leave.
- When the game server starts, the number of simulated bots becomes the target for CoD Xe's existing GSC test-client bot manager. At VM shutdown, the prototype records the local test clients still connected so that count can persist into the next lobby.

## Future expansion: shared Xbox Live lobby bots

The current `addtestclient()` implementation creates an `NA_BOT` on the local game server. It does not create an authenticated Xbox Live session member or a party XUID, so other lobby participants cannot see these bots and the bots cannot cast real party votes. Expanding to shared lobby membership requires a separate, carefully tested implementation of Party/XSession membership and replicated party-state/vote handling; the host-local overlay must not be mistaken for that functionality.
