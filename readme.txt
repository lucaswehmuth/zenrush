Project Summary — Godot 4 Mobile Roguelite
The Game
Top-down auto-attack shooter roguelite for mobile (Android primary, iOS secondary). Single reference: Survivor.io / Archero. Hard-capped 10-minute runs. Mid-run upgrade selection. Persistent shard-based meta progression. Player auto-attacks nearest visible enemy. One active special ability button (not yet implemented).

Lucas's Preferences
Game feel: Approachable difficulty, short sessions, addictive daily grind, Tibia-like endless progression feeling. Hates overly complex or bloated systems (see: Archero's monetization).
Code: Typed GDScript, composition where it makes sense, no magic numbers, no unjustified singletons, consistent class_name conventions, clean separation of responsibilities. Pushes back hard on over-engineered solutions. Wants to understand reasoning before accepting implementations.
Weaknesses: Tendency toward excitement paralysis and tangents. Manages this through structured planning and parking lot approach.

Current Architecture
Core Scenes

World — root scene, orchestrates everything via signals
MainMenu — entry point, shows total shards, leads to game or upgrade screen
Sandbox — dev testing scene, enemies don't move, upgrade pickups on floor, quick reset

Key Nodes in World
World (Node2D) — world.gd
├── Player
├── SpawnManager
├── UpgradeManager
├── SaveManager
└── CanvasLayer
    ├── TimerLabel
    ├── UpgradeScreen
    └── EndScreen

Player (player.gd)
CharacterBody2D. Handles movement (virtual joystick), auto-attack targeting (nearest visible enemy within dynamic range), projectile spawning, health, death signal. Key properties:

move_speed, base_damage, attack_cooldown, base_attack_cooldown
attack_range, burst_count, extra_shots
health_regen, vampirism, shard_magnet
completion_bonus_multiplier
projectile_upgrades: Array[BaseProjectileUpgrade]
player_upgrades: Array[BasePlayerUpgrade]


Enemy Architecture
BaseEnemy (CharacterBody2D)
├── RusherEnemy
├── TankEnemy
├── RangedEnemy
└── BaseEnemy (used as weak minion placeholder)
All enemies have Hurtbox and Hitbox (Area2D) children. BaseEnemy has died(enemy) signal. Enemies find player via "player" group.

Projectile
BaseProjectile (Area2D)
Has shooter string ("player" or "enemy"), speed, damage, pierce_count, explodes, explosion_radius, explosion_damage_multiplier. Spawns ProjectileExplosion scene on impact if explosive.

Hitbox / Hurtbox

Hitbox (Area2D) — dumb shape, no properties
Hurtbox (Area2D) — detects Hitbox, emits hurt(hitbox) signal. Parent reads hitbox.get_parent() to identify attacker.


Upgrade Architecture
BaseUpgrade (Resource)
├── BasePlayerUpgrade → apply(player)
│   ├── AttackSpeedUpgrade
│   ├── DamageUpgrade
│   ├── MaxHealthUpgrade
│   ├── MoveSpeedUpgrade
│   ├── HealthRegenUpgrade
│   ├── VampirismUpgrade
│   ├── AttackRangeUpgrade
│   ├── BurstUpgrade
│   ├── MultiShotUpgrade
│   ├── OrbUpgrade (spawns OrbitalOrb nodes on player)
│   └── ShardMagnetUpgrade
└── BaseProjectileUpgrade → apply(projectile)
    ├── PierceUpgrade
    ├── ExplosiveUpgrade
    └── ProjectileSizeUpgrade
BaseUpgrade has upgrade_name, description, icon, category (enum: HP, ATTACK, SPECIAL). Each upgrade sets these in _init().

Managers

SpawnManager — enemy spawning, difficulty scalar, run timer, upgrade trigger signal every 60s, enemy culling beyond screen diagonal * 1.5
UpgradeManager — owns upgrade pool, picks 2 random offers, removes chosen upgrade from pool for rest of run
SaveManager — ConfigFile based persistence, total shards saved/loaded. Regular node, not autoload.


Special Nodes

HealthBar — reusable ProgressBar with damage bar tween effect. Used on both player and enemies.
OrbitalOrb — Area2D child of player, rotates around player using angle math, damages enemies on overlap with per-enemy cooldown dictionary.
Shard — Area2D pickup, optional attraction toward player via attract() which enables _physics_process.
ProjectileExplosion — Area2D scene with CPUParticles2D, queries overlapping hurtboxes after 2 physics frames.


Milestones Status
✅ Milestone 1 — Movement & Combat Feel
✅ Milestone 2 — Enemy Variety & Game Loop
✅ Milestone 4 — Run Reward Screen & Shard Banking
✅ Milestone 6 — Upgrade System (mid-run)
🔲 Milestone 3 — Special Attack Button (deprioritized, reconsidering)
🔲 Milestone 5 — Meta Progression (next up)
🔲 Milestone 7 — Game Feel & Juice
🔲 Milestone 8 — Mobile Export & Device Testing
🔲 Milestone 9 — Playtest & Balance
🔲 Milestone 10 — Release

Milestone 5 Plan — Meta Progression ("Shrine" or "Vault" — name TBD)
Three upgrade trees, visible grid UI, locked nodes shown greyed out:
SURVIVAL 🟢 — Max HP, Health Regen → unlocks Vampirism → unlocks Move Speed
ATTACK 🔴 — Damage, Attack Speed, Attack Range → unlocks Explosive Radius + Explosive Damage
FORTUNE 🟡 — Boss Spawn Chance, Completion Bonus Multiplier → unlocks Daily Bonus → unlocks Second Chance
Cost curve: base_cost(50) * level^2. Max 5 levels per node.
A rare boss spawns in the final minute of a run, chance influenced by Fortune tree. Drops large shard reward. V1 boss is simple — just a beefed up enemy. Full boss mechanics parked for V2.
