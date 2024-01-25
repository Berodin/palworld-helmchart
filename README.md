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

- **replicaCount**: Number of replicas for the deployment.
- **image**: Docker image details.
- **resources**: CPU and memory limits and requests.
- **persistence**: Configuration for persistent storage.
- **env**: Environment variables for server configuration.

### Environment Variables

Configure your server using these environment variables:

| Variable       | Description                                          | Default Value | Allowed Values                                      |
|----------------|------------------------------------------------------|---------------|-----------------------------------------------------|
| `PLAYERS`      | Maximum number of players                            | 10            | Integer                                             |
| `PORT`         | Server port                                          | 27015         | Integer (1024-65535)                                |
| `PUID`         | User ID for the server process                       | 1000          | Integer                                             |
| `PGID`         | Group ID for the server process                      | 1000          | Integer                                             |
| `MULTITHREADING`| Enable/disable multithreading                       | "false"       | "true" / "false"                                    |
| `COMMUNITY`    | Community server visibility                          | "false"       | "true" / "false"                                    |
| `PUBLIC_IP`    | Manual specification of the server's public IP       |               | IP Address                                          |
| `PUBLIC_PORT`  | Manual specification of the server's public port     |               | Integer (1024-65535)                                |
| `SERVER_PASSWORD`| Server password for secure access                  |               | String                                              |
| `SERVER_NAME`  | Name of the server                                   | "My Palworld Server" | String                                       |
| `ADMIN_PASSWORD`| Admin password for secure server administration     |               | String                                              |
| `UPDATE_ON_BOOT`| Enable/disable server update on boot                | "true"        | "true" / "false"                                    |

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
