# code
A code environment based on Ubuntu and VSCode tunnels.

Here is the `docker-compose.yml` that powers the whole setup.

```yaml
version: '3'
services:
  code:
    image: ghcr.io/ar10dev/code:latest
    container_name: code
    ports:
      - 7000:8000
      - 3000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - /home/ubuntu/projects:/home/code/workspace
      - /home/ubuntu/.vscode-cli:/home/code/.vscode-cli
      # VSCode extensions folder
      - /home/ubuntu/.vscode-server/extensions:/home/code/.vscode-server/extensions
      # Git Config
      - /home/ubuntu/.gitconfig:/home/code/.gitconfig
```
