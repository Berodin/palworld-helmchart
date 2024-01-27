# Palworld Dedicated Server for Kubernetes

This documentation provides a guide on deploying and managing a Palworld dedicated server using Dockerimages and Kubernetes in a Raspberry Pi environment. Palworld is a popular game available on [Steam](https://store.steampowered.com/app/1623730/Palworld/), and this guide covers the configuration and management of its dedicated server.

## Overview

This Docker container for the Palworld dedicated server is only compatible with arm64 and uses [FEX](https://github.com/FEX-Emu/FEX). The configuration involves Kubernetes YAML files and environment variables to customize the server setup.

### Kubernetes Deployment

The Kubernetes deployment is managed through various YAML files, each serving a specific purpose:

- `values.yaml`: Defines the default values for the server's deployment.
- `service.yaml`: For setting up the Kubernetes service.
- `secret.yaml`: To manage secrets like server and admin passwords.
- `deployment.yaml`: Defines the deployment setup.
- `configmap.yaml`: For non-sensitive configuration data.
- `_helpers.tpl`: Template helpers for consistent naming and labeling.

#### `values.yaml` Structure

| Key               | Description                                           | Default Value                          |
|-------------------|-------------------------------------------------------|----------------------------------------|
| `replicaCount`    | Number of pod replicas in the deployment              | `1`                                    |
| `image.repository`| Docker image repository for the server                | `"your-docker-image-repo/palworld"`    |
| `image.pullPolicy`| Image pull policy                                     | `"IfNotPresent"`                       |
| `image.tag`       | Image tag                                             | `"latest"`                             |
| `securityContext` | Security context for the pod                          | `{ runAsUser: 1001, runAsGroup: 1001, fsGroup: 1001 }` |
| `resources`       | CPU and memory requests                               | `{ requests: { cpu: "500m", memory: "1024Mi" } }` |
| `persistence`     | Persistent storage options                            | `{ enabled: true, serverdir: { existingClaim: "" } }` |
| `env`             | Environment variables for server configuration       | Detailed below                         |
| `palWorldSettings`| Game-specific settings                                | Detailed below                         |
| `secrets`         | Sensitive information like passwords and IP addresses | `{ AdminPassword: "D0n01tRyTh4t", ServerPassword: "", PublicIP: "" }` |

#### Environment Variables

| Variable          | Description                                  | Default Value |
|-------------------|----------------------------------------------|---------------|
| `PUID`            | User ID for the server process               | `1000`        |
| `PLAYERS`         | Maximum number of players                    | `10`          |
| `MULTITHREADING`  | Enable/disable multithreading                | `"false"`     |
| `COMMUNITY`       | Community server visibility                  | `"false"`     |
| `UPDATE_ON_BOOT`  | Update server on boot                        | `"true"`      |
| `PORT`            | Port for server communication                | `27015`       |

### Game Settings (`palWorldSettings`)

The `palWorldSettings` section provides a comprehensive list of game-specific settings, allowing fine-tuning of the gameplay experience. These settings cover a wide range of aspects from general server settings to gameplay mechanics, player and Pal behavior, and server and guild management.

#### General Settings

| Key                  | Description                                | Default Value   |
|----------------------|--------------------------------------------|-----------------|
| `Difficulty`         | Overall game difficulty                    | `None`          |
| `ServerName`         | Name of the server                         | `"MyPaltopia"`  |
| `ServerDescription`  | Brief description of the server            | `""`            |
| `PublicPort`         | Port for public server access              | `8211`          |
| `Region`             | Geographic region of the server            | `""`            |

#### Rate Adjustments

| Key                           | Description                                        | Default Value |
|-------------------------------|----------------------------------------------------|---------------|
| `DayTimeSpeedRate`            | Speed of day/night cycle                           | `1.000000`    |
| `NightTimeSpeedRate`          | Speed of night/day cycle                           | `1.000000`    |
| `ExpRate`                     | Experience points rate                             | `1.000000`    |
| `PalCaptureRate`              | Rate of capturing Pals                             | `1.000000`    |
| `PalSpawnNumRate`             | Rate of Pal spawning                               | `1.000000`    |
| `CollectionDropRate`          | Rate of item drop from collection                  | `1.000000`    |
| `CollectionObjectHpRate`      | Health points of collectible objects               | `1.000000`    |
| `CollectionObjectRespawnSpeedRate` | Respawn rate of collectible objects             | `1.000000`    |
| `EnemyDropItemRate`           | Item drop rate from enemies                        | `1.000000`    |
| `WorkSpeedRate`               | Rate of work or activity speed                     | `1.000000`    |

#### Player and Pal Settings

| Key                           | Description                                        | Default Value |
|-------------------------------|----------------------------------------------------|---------------|
| `PlayerDamageRateAttack`      | Player's damage rate for attack                    | `1.000000`    |
| `PlayerDamageRateDefense`     | Player's damage rate for defense                   | `1.000000`    |
| `PlayerStomachDecreaceRate`   | Rate of stomach decrease for the player            | `1.000000`    |
| `PlayerStaminaDecreaceRate`   | Rate of stamina decrease for the player            | `1.000000`    |
| `PlayerAutoHPRegeneRate`      | Auto health regeneration rate for the player       | `1.000000`    |
| `PlayerAutoHpRegeneRateInSleep` | Auto health regen rate for the player in sleep    | `1.000000`    |
| `PalDamageRateAttack`         | Pal's damage rate for attack                       | `1.000000`    |
| `PalDamageRateDefense`        | Pal's damage rate for defense                      | `1.000000`    |
| `PalStomachDecreaceRate`      | Rate of stomach decrease for Pals                  | `1.000000`    |
| `PalStaminaDecreaceRate`      | Rate of stamina decrease for Pals                  | `1.000000`    |
| `PalAutoHPRegeneRate`         | Auto health regeneration rate for Pals             | `1.000000`    |
| `PalAutoHpRegeneRateInSleep`  | Auto health regen rate for Pals in sleep           | `1.000000`    |

#### Building and Object Settings

| Key                           | Description                                        | Default Value |
|-------------------------------|----------------------------------------------------|---------------|
| `BuildObjectDamageRate`       | Damage rate for building objects                   | `1.000000`    |
| `BuildObjectDeteriorationDamageRate` | Deterioration rate for building objects       | `1.000000`    |

#### Gameplay Mechanics

| Key                               | Description                                       | Default Value |
|-----------------------------------|---------------------------------------------------|---------------|
| `DeathPenalty`                    | Type of penalty on death                          | `All`         |
| `bEnablePlayerToPlayerDamage`     | Enable/disable damage between players             | `False`       |
| `bEnableFriendlyFire`             | Enable/disable friendly fire                      | `False`       |
| `bEnableInvaderEnemy`             | Enable/disable invader enemies                    | `True`        |
| `bActiveUNKO`                     | Unknown setting                                   | `False`       |
| `bEnableAimAssistPad`             | Enable/disable aim assist for pad                 | `True`        |
| `bEnableAimAssistKeyboard`        | Enable/disable aim assist for keyboard            | `False`       |
| `bIsMultiplay`                    | Enable/disable multiplayer mode                   | `False`       |
| `bIsPvP`                          | Enable/disable Player vs Player mode              | `False`       |
| `bCanPickupOtherGuildDeathPenaltyDrop` | Allow/disallow picking up items dropped on death by other guilds | `False` |
| `bEnableNonLoginPenalty`          | Enable/disable penalty for not logging in         | `True`        |
| `bEnableFastTravel`               | Enable/disable fast travel                        | `True`        |
| `bIsStartLocationSelectByMap`     | Enable/disable start location selection by map    | `True`        |
| `bExistPlayerAfterLogout`         | Keep/disappear player character after logout      | `False`       |
| `bEnableDefenseOtherGuildPlayer`  | Enable/disable defense against other guild players| `False`       |

#### Server and Guild Settings

| Key                               | Description                                       | Default Value |
|-----------------------------------|---------------------------------------------------|---------------|
| `DropItemMaxNum`                  | Maximum number of drop items                      | `3000`        |
| `DropItemMaxNum_UNKO`             | Maximum number of UNKO items                      | `100`         |
| `BaseCampMaxNum`                  | Maximum number of base camps                      | `128`         |
| `BaseCampWorkerMaxNum`            | Maximum number of workers for base camps          | `15`          |
| `DropItemAliveMaxHours`           | Hours that dropped items remain                   | `1.000000`    |
| `bAutoResetGuildNoOnlinePlayers`  | Auto reset guild when no players are online       | `False`       |
| `AutoResetGuildTimeNoOnlinePlayers` | Time for auto reset of guild                     | `72.000000`   |
| `GuildPlayerMaxNum`               | Maximum number of players in a guild              | `20`          |
| `CoopPlayerMaxNum`                | Maximum number of players in co-op                | `4`           |
| `ServerPlayerMaxNum`              | Maximum number of players in server               | `32`          |
| `PalEggDefaultHatchingTime`       | Default hatching time for Pal eggs                | `72.000000`   |

#### RCON and Security

| Key               | Description                                 | Default Value                         |
|-------------------|---------------------------------------------|---------------------------------------|
| `RCONEnabled`     | Enable RCON for remote server management    | `False`                               |
| `RCONPort`        | Port for RCON communication                 | `25575`                               |
| `bUseAuth`        | Enable/disable authentication               | `True`                                |
| `BanListURL`      | URL for the ban list                        | `"https://api.palworldgame.com/api/banlist.txt"` |

#### Secrets Management

Sensitive information is handled in the `secrets` section:

| Key               | Description                                 | Default Value                         |
|-------------------|---------------------------------------------|---------------------------------------|
| `AdminPassword`     | Administrative password for secure server management.    | `nil`                |
| `ServerPassword`    | Password for secure server access.              | `nil`                         |
| `PublicIP`        | Public IP address of the server.               | `nil`                                |


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
