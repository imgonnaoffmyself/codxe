# IW3 host-local public lobby bot prototype

## Current prototype scope

- The feature is gated to the open console menu asset `menu_xboxlive_lobby`, an online game host, a non-private match, and a user who is not marked as either the private-party host or a private-party client. The asset is tracked from the native UI menu stack; no `UIMENU_GAMELOBBY` enum or `inlobby` dvar is used as the menu gate.
- It simulates local roster rows through the existing native UI feeder hooks. The lobby's native member feeder is identified at runtime by matching the host name against the native feeder text; synthetic names are returned only for the additional local rows. The feeder's reported row count is expanded locally, while the Xbox Live roster and its count dvar remain untouched.
- These rows are a host-only UI simulation, not authenticated Xbox Live session members. They are not replicated to remote lobby members and cannot alter the authoritative party/session roster.
- When the native map-veto UI is visible, each simulated row gets a local `SKIP` or `KEEP` vote. If the veto-status dvar is not marked for replication, the prototype appends a local simulated tally to its display string. It does not submit votes to Xbox Live or change the session's veto result.
- Simulated arrivals use a randomized interval interpolated from 5–30 seconds at one lobby occupant to 0.33–2.5 seconds at eight or more occupants. Every two seconds there is a 10% chance that one or two simulated bots leave.
- When a match starts, the simulated bot count is passed to the existing GSC test-client manager. At VM shutdown, remaining local test clients are captured so they can be represented again in the post-game lobby UI.

## Future expansion: shared Xbox Live lobby bots

The existing `addtestclient()` path creates `NA_BOT` clients on the local game server. It does not create authenticated Xbox Live session members or party XUIDs. Shared visibility and real party votes require a console-side Party/XSession membership implementation; the current host-local UI simulation must not be mistaken for that functionality.
