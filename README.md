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
      # VSCode Cli Data
      - /home/ubuntu/.vscode-data:/home/code/.vscode-data
      # Git Config
      - /home/ubuntu/.gitconfig:/home/code/.gitconfig
```
