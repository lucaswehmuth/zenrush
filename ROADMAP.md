# 🗺️ Roadmap

> Each milestone has a clear **done condition**. A milestone is only done when you can demo it — not when you think it's ready. Do not start the next milestone until the current one is demoed.

---

## Milestone 1 — Movement & Combat Feel
**Goal:** Player moves and attacks. Feels good on a real device. Nothing else matters yet.

**Done condition:** You can move around, auto-attack dummy enemies, and the whole thing runs smoothly on your phone.

### Tasks
- [ ] Create project structure and folder conventions
- [ ] Create `Player` scene with `CharacterBody2D`
- [ ] Implement virtual joystick input for movement
- [ ] Implement auto-attack logic (target nearest enemy, attack on interval)
- [ ] Create `Enemy` dummy scene (static circle, no behavior yet)
- [ ] Implement melee hitbox with `Area2D` + `CollisionShape2D`
- [ ] Add attack animation states (idle, attack) using `AnimationTree`
- [ ] First on-device test — feel the controls, adjust movement speed and attack rate
- [ ] Tune movement speed, attack range, and attack interval until it feels right

---

## Milestone 2 — Enemy Variety & Game Loop
**Goal:** Three enemy types. You can die. You can restart. There is tension.

**Done condition:** You can play a full session from spawn to death with all three enemy types present, then restart cleanly.

### Tasks
- [ ] Implement `Rusher` enemy — moves directly toward player, deals contact damage
- [ ] Implement `Ranged` enemy — keeps distance, fires projectile toward player
- [ ] Implement `Tank` enemy — slow, high HP, contact damage
- [ ] Implement player health and hurt state
- [ ] Implement death screen with waves survived stat
- [ ] Implement restart without reloading the full game
- [ ] Implement basic wave spawner (escalating enemy count over time)
- [ ] Implement enemy spawn positions (off-screen, random edges)
- [ ] Balance basic feel — does mixed wave create interesting pressure?

---

## Milestone 3 — Special Attack Button
**Goal:** One active ability the player can trigger. Has a cooldown. Feels impactful.

**Done condition:** Special button is on screen, triggers a satisfying AoE effect, has a visible cooldown, and is balanced enough to not trivialise combat.

### Tasks
- [ ] Design first special ability — AoE pulse around player (simplest, most readable)
- [ ] Implement special attack `Area2D` with short lifetime
- [ ] Add visual feedback — particles or screen flash on trigger
- [ ] Add cooldown timer and cooldown UI indicator on the button
- [ ] Tune cooldown duration and damage until it feels like a meaningful choice
- [ ] Ensure special button touch target is correctly sized and positioned
- [ ] On-device test — does the button feel natural with right thumb?

---

## Milestone 4 — Run Reward Screen & Shard Banking
**Goal:** Death feels rewarding. Shards are earned and persisted. Nothing to spend yet.

**Done condition:** On death you see a screen showing waves survived and shards earned. Shards accumulate across runs and survive app restarts.

### Tasks
- [ ] Design shard earn formula (e.g. 1 shard per wave + bonus for enemies killed)
- [ ] Implement run summary screen (waves survived, enemies killed, shards earned)
- [ ] Implement persistent save using `ConfigFile` or `FileAccess` in Godot 4
- [ ] Display total banked shards on death screen and on main menu
- [ ] Implement scene flow: game → death screen → main menu → game
- [ ] Test save persistence — close app fully, reopen, shards still there

---

## Milestone 5 — First Meta Upgrade
**Goal:** Spend shards. Feel the loop. One single upgradeable stat is enough.

**Done condition:** You can spend shards to upgrade max health, start a new run, and feel the difference. The loop is complete.

### Tasks
- [ ] Design upgrade screen UI (simple, one node to start — max health)
- [ ] Implement shard spend logic with confirmation
- [ ] Implement upgrade level cap (e.g. max 5 levels for V1)
- [ ] Apply upgrade to player stats at run start
- [ ] Show current upgrade level and cost of next level on screen
- [ ] Add 2-3 more meta nodes across different tracks (attack speed, shard bonus)
- [ ] Full loop playtest — run, die, upgrade, run again. Does it feel rewarding?

---

## Milestone 6 — Run Modifier System
**Goal:** Player picks a modifier before each run. Runs feel distinct from each other.

**Done condition:** Pre-run modifier selection screen works, at least 3 modifiers exist, and each one noticeably changes how a run plays.

### Tasks
- [ ] Design modifier data structure as a `Resource` class
- [ ] Implement 4 modifiers (Berserker, Vampiric, Overclock, Fortress — see README)
- [ ] Build pre-run selection screen (pick 1 of 2 random options)
- [ ] Apply modifier effects to player stats at run start
- [ ] Unlock modifiers through meta tree (first one free, others gated)
- [ ] Playtest each modifier — does each one actually change player behavior?

---

## Milestone 7 — Game Feel & Juice
**Goal:** The game stops looking like a prototype and starts feeling like a game.

**Done condition:** You would not be embarrassed to show this to a stranger.

### Tasks
- [ ] Add screen shake on player hit
- [ ] Add hit flash on enemies when damaged
- [ ] Add particle effects on enemy death
- [ ] Add particle or visual effect on special attack
- [ ] Add basic sound effects (attack, hit, death, special, UI tap)
- [ ] Add background music (loopable, royalty free)
- [ ] Replace placeholder squares/circles with simple custom sprites
- [ ] Add simple arena background (tilemap or textured plane)
- [ ] Polish UI — health bar, wave counter, shard display, special cooldown

---

## Milestone 8 — Mobile Export & Device Testing
**Goal:** The game runs on Android and iOS without issues.

**Done condition:** A build is installed on at least one Android and one iOS device and plays without crashes, input issues, or performance drops.

### Tasks
- [ ] Set up Android export in Godot 4 (keystore, package name, permissions)
- [ ] Set up iOS export if applicable
- [ ] Handle safe area insets for notches and home indicators
- [ ] Test all touch inputs on real device
- [ ] Profile performance — maintain 60fps on target device
- [ ] Fix any mobile-specific bugs

---

## Milestone 9 — Playtest & Balance
**Goal:** Real people play it and you learn something.

**Done condition:** 5 people outside your own head have played it and you have acted on their feedback.

### Tasks
- [ ] Internal playtest — play 20 full runs, note every friction point
- [ ] Identify and fix top 5 friction points
- [ ] External playtest with 5 players (friends, family, online community)
- [ ] Collect feedback on difficulty curve, controls, and session length feel
- [ ] Balance wave escalation based on feedback
- [ ] Balance meta progression cost curve based on feedback

---

## Milestone 10 — Release
**Goal:** It ships.

**Done condition:** The game is live on at least one app store.

### Tasks
- [ ] Write app store description
- [ ] Create app store screenshots (minimum 3)
- [ ] Create app icon (all required sizes)
- [ ] Write privacy policy (required by both stores even for free apps)
- [ ] Submit to Google Play
- [ ] Submit to App Store if applicable
- [ ] Monitor crash reports post-launch

---

## 🅿️ Post-V1 Backlog
*Ideas parked from the parking lot in README. Revisit after launch.*

- Swipe gesture special attack
- Boss fights at wave milestones
- Multiple playable characters
- Gear / equipment system
- Online leaderboards
- Multiple arenas / biomes
- Combo meter system
- Crafting or item merging
