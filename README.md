
# KASM MeshChat Workspace

This project provides a custom KASM workspace for running [Reticulum MeshChat](https://github.com/liamcottle/reticulum-meshchat), a decentralized chat application built on the Reticulum Network Stack.

## Description

This KASM workspace provides a containerized environment for running MeshChat with a web-based interface. It's built on top of the KASM Ubuntu Jammy desktop image and includes all necessary dependencies for running MeshChat.

## Features

- Pre-configured MeshChat installation
- Web-based interface accessible through KASM
- Customizable Reticulum network interfaces
- Automatic startup of MeshChat service
- Desktop shortcut for easy access

## Prerequisites

- Docker installed on your system
- KASM Workspaces server (if running as part of KASM infrastructure)

## Building the Image

1. Clone this repository:
```bash
git clone https://github.com/cwilliams001/kasm-meshchat.git
cd kasm-meshchat
```

2. Build the Docker image:
```bash
docker build -t yourusername/kasm-meshchat:latest .
```

3. (Optional) Push to Docker Hub:
```bash
docker push yourusername/kasm-meshchat:latest
```

## Configuration

### Reticulum Network Interfaces

The default configuration includes several pre-configured network interfaces. You can customize these by modifying the `config` file before building the image.

The default configuration includes:
- Default Interface (AutoInterface) - Note it is commented out by default.
- RNS Testnet BetweenTheBorders
- RNS Testnet Amsterdam

To modify the network interfaces, edit the `config` file in the repository before building.


### Installing in KASM Workspaces

1. In KASM admin interface, go to Workspaces
2. Click "Add Workspace"
3. Add the Docker image: `yourusername/kasm-meshchat:latest`
4. Configure other settings as needed
5. Save and launch the workspace


## License

This project is licensed under the [MIT License](LICENSE) - see the LICENSE file for details.

## Acknowledgments

- [Reticulum Project](https://github.com/markqvist/Reticulum) by Mark Qvist
- [Reticulum MeshChat](https://github.com/liamcottle/reticulum-meshchat) by Liam Cottle
- [KASM Workspaces](https://www.kasmweb.com/) for the base container images
