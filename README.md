# RaspiSync

A configurable Zsh function to sync project content to a Raspberry Pi via SSH and execute scripts remotely.

## Requirements

- `ssh`
- `sshpass`

## Tested On

- macOS
- Raspberry Pi 5

## How It Works

RaspiSync is designed to be reused across multiple projects. Each project carries its own `.env` file that provides the connection and execution details. When you run the command from within a project directory, it reads that configuration, syncs the project files to the Pi over SSH, and runs the specified script remotely.

This approach works with any Python version or version manager. The dependencies only need to be installed on the Pi once. If dependencies change, they must be reinstalled manually on the Pi. The same pattern could also be adapted for other runtimes such as Node.js.

## Configuration

Create a `.env` file in your project directory with the following variables:

```
SSH_HOST=
SSH_PASSWORD=
SSH_SUDO_PASSWORD=
SSH_PROJECT_PATH=
SSH_PYTHON_EXEC=
```

| Variable | Description |
|---|---|
| `SSH_HOST` | Hostname or IP address of the Raspberry Pi |
| `SSH_PASSWORD` | Password used for SSH authentication |
| `SSH_SUDO_PASSWORD` | Password used for sudo commands on the Pi |
| `SSH_PROJECT_PATH` | Absolute path to the project directory on the Pi |
| `SSH_PYTHON_EXEC` | Python executable to use on the Pi (e.g. `python3`) |

## Usage

Run the command from the root of your project:

```sh
raspisync
```
