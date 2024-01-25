# Palworld Dedicated Server Docker

This documentation provides a comprehensive guide on deploying and managing a Palworld dedicated server using Docker and Kubernetes in a Raspberry Pi environment. Palworld is a popular game available on [Steam](https://store.steampowered.com/app/1623730/Palworld/), and this guide covers the configuration and management of its dedicated server.

## Overview

This Docker container for the Palworld dedicated server is only compatible with arm64 at the moment. The configuration involves Kubernetes YAML files and environment variables to customize the server setup.

### Kubernetes Deployment

The Kubernetes deployment is managed through various YAML files, each serving a specific purpose:

1. `values.yaml`: Defines the default values for the server's deployment.
2. `service.yaml`: For setting up the Kubernetes service.
3. `secret.yaml`: To manage secrets like server and admin passwords.
4. `deployment.yaml`: Defines the deployment setup.
5. `configmap.yaml`: For non-sensitive configuration data.
6. `_helpers.tpl`: Template helpers for consistent naming and labeling

#### `values.yaml` Structure

The `values.yaml` file is the central configuration file. Here's an overview of its structure:

1. **replicaCount**: Specifies the number of pod replicas in the Kubernetes deployment.
2. **image**: Defines the Docker image details for the server.
3. **resources**: Sets the CPU and memory requests.
4. **persistence**: Configures persistent storage options.
5. **env**: Lists essential environment variables for the server.
6. **palWorldSettings**: Details specific game settings.
7. **secrets**: Contains sensitive information like passwords and IP addresses.

#### Detailed Breakdown

Here's a detailed breakdown of each section:

- **replicaCount**: `1`
- **image**:
  - `repository`: "your-docker-image-repo/palworld"
  - `pullPolicy`: "IfNotPresent"
  - `tag`: "latest"
- **resources**:
  - `requests`:
    - `cpu`: "500m"
    - `memory`: "1024Mi"
- **persistence**:
  - `enabled`: `true`
  - `serverdir`:
    - `existingClaim`: ""
- **env**:
  - `PUID`: `1000`
  - `PLAYERS`: `10`
  - `MULTITHREADING`: `"false"`
  - `COMMUNITY`: `"false"`
  - `UPDATE_ON_BOOT`: `"true"`
- **palWorldSettings**: Custom game settings (like `Difficulty`, `DayTimeSpeedRate`, `ExpRate`, etc.)
- **secrets**:
  - `AdminPassword`: "D0n01tRyTh4t"
  - `ServerPassword`: ""
  - `PublicIP`: ""

### Environment Variables

Update the server settings using these environment variables:

| Variable          | Description                                  | Default Value      | Allowed Values                                      |
|-------------------|----------------------------------------------|--------------------|-----------------------------------------------------|
| `PUID`            | User ID for the server process               | 1000               | Integer                                             |
| `PLAYERS`         | Maximum number of players                    | 10                 | Integer                                             |
| `MULTITHREADING`  | Enable/disable multithreading                | "false"            | "true" / "false"                                    |
| `COMMUNITY`       | Community server visibility                  | "false"            | "true" / "false"                                    |
| `UPDATE_ON_BOOT`  | Update server on boot                        | "true"             | "true" / "false"                                    |


### Game Settings (`palWorldSettings`)

1. **General Settings**
   - `Difficulty`: Sets the overall game difficulty (e.g., None, Easy, Hard).
   - `ServerName`: Name of your server (e.g., "MyPaltopia").
   - `ServerDescription`: A brief description of your server.
   - `PublicPort`: Port for public server access (e.g., 8211).
   - `Region`: Geographic region setting for the server.

2. **Rate Adjustments**
   - `DayTimeSpeedRate`, `NightTimeSpeedRate`: Adjust the speed of day/night cycle.
   - `ExpRate`: Experience points rate.
   - `PalCaptureRate`: Rate of capturing Pals.
   - `PalSpawnNumRate`: Rate of Pal spawning.
   - `CollectionDropRate`: Rate of item drop from collection.
   - `CollectionObjectHpRate`: Health points of collectible objects.
   - `CollectionObjectRespawnSpeedRate`: Respawn rate of collectible objects.
   - `EnemyDropItemRate`: Item drop rate from enemies.
   - `WorkSpeedRate`: Rate of work or activity speed.

3. **Player and Pal Settings**
   - `PlayerDamageRateAttack`, `PlayerDamageRateDefense`: Player's damage rates for attack and defense.
   - `PlayerStomachDecreaceRate`, `PlayerStaminaDecreaceRate`: Rate of stomach decrease and stamina decrease for the player.
   - `PlayerAutoHPRegeneRate`, `PlayerAutoHpRegeneRateInSleep`: Auto health regeneration rates for the player.
   - `PalDamageRateAttack`, `PalDamageRateDefense`: Pal's damage rates for attack and defense.
   - `PalStomachDecreaceRate`, `PalStaminaDecreaceRate`: Rate of stomach decrease and stamina decrease for Pals.
   - `PalAutoHPRegeneRate`, `PalAutoHpRegeneRateInSleep`: Auto health regeneration rates for Pals.

4. **Building and Object Settings**
   - `BuildObjectDamageRate`: Damage rate for building objects.
   - `BuildObjectDeteriorationDamageRate`: Deterioration rate for building objects.

5. **Gameplay Mechanics**
   - `DeathPenalty`: Type of penalty on death (e.g., All, None).
   - `bEnablePlayerToPlayerDamage`: Enable/disable damage between players.
   - `bEnableFriendlyFire`: Enable/disable friendly fire.
   - `bEnableInvaderEnemy`: Enable/disable invader enemies.
   - `bActiveUNKO`: Unknown setting (True/False).
   - `bEnableAimAssistPad`, `bEnableAimAssistKeyboard`: Enable/disable aim assist for pad and keyboard.
   - `bIsMultiplay`: Enable/disable multiplayer mode.
   - `bIsPvP`: Enable/disable Player vs Player mode.
   - `bCanPickupOtherGuildDeathPenaltyDrop`: Allow/disallow picking up items dropped on death by other guilds.
   - `bEnableNonLoginPenalty`: Enable/disable penalty for not logging in.
   - `bEnableFastTravel`: Enable/disable fast travel.
   - `bIsStartLocationSelectByMap`: Enable/disable start location selection by map.
   - `bExistPlayerAfterLogout`: Keep/disappear player character after logout.
   - `bEnableDefenseOtherGuildPlayer`: Enable/disable defense against other guild players.

6. **Server and Guild Settings**
   - `DropItemMaxNum`, `DropItemMaxNum_UNKO`: Maximum number of drop items and UNKO items.
   - `BaseCampMaxNum`, `BaseCampWorkerMaxNum`: Maximum number of base camps and workers.
   - `DropItemAliveMaxHours`: Hours that dropped items remain.
   - `bAutoResetGuildNoOnlinePlayers`: Auto reset guild when no players are online.
   - `AutoResetGuildTimeNoOnlinePlayers`: Time for auto reset of guild.
   - `GuildPlayerMaxNum`: Maximum number of players in a guild.
   - `CoopPlayerMaxNum`, `ServerPlayerMaxNum`: Maximum number of players in co-op and server.
   - `PalEggDefaultHatchingTime`: Default hatching time for Pal eggs.

7. **RCON and Security**
   - `RCONEnabled`, `RCONPort`: Enable RCON and set its port.
   - `bUseAuth`: Enable/disable authentication.
   - `BanListURL`: URL for the ban list.

8. **Secrets**
   - `AdminPassword`: Administrative password for secure server management.
   - `ServerPassword`: Password for secure server access.
   - `PublicIP`: Public IP address of the server.

### Secrets Management

Sensitive information is handled in the `secrets` section:

- **AdminPassword**: ""
- **ServerPassword**: ""
- **PublicIP**: ""

### Game Ports Configuration

The server exposes several ports for different purposes:

- TCP and UDP query ports (27015).
- TCP and UDP game ports (8211).

### RCON Management

RCON is used for remote management of the server. It allows execution of server commands through a CLI.

RCON is not used at the moment.

#### RCON Commands

Common server commands include `Shutdown`, `DoExit`, `Broadcast`, and more. For a full list of commands, visit [Palworld Server Commands](https://tech.palworldgame.com/server-commands).

### Reporting Issues and Feature Requests


This documentation serves as a comprehensive guide for deploying and managing a Palworld dedicated server using Docker and Kubernetes in a Raspberry Pi environment, tailored to both beginners and experienced users.
