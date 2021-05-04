# Helm

```sh
brew install helm
```

## Search and install charts (artifacts)

```sh
# List all
helm search hub
# Search by name
helm search hub <name>
# List local
helm search repo
# Add to local repo
helm repo add <name> <url>
# Update local repos
helm repo update
# Remove a repo
helm repo remove
```

## Install a chart

```sh
helm install <release-name> <chart-name>
helm install test-release-123 stable/mysql
helm install stable/mysql --generate-name
# Get current status
helm status test-release-123
# Show installed
helm ls
```

## Pre Installation
```sh
# Display chart values
helm show values
# Create custom values in a yaml file
echo '{mariadb.auth.database: user0db, mariadb.auth.username: user0}' > values.yaml
# Install with the new values
helm install -f values.yaml bitnami/wordpress --generate-name
# Or directly in the command line without a file
helm install --set a=b,c=d,outer.inner=value,names={a,b,c},servers[0].port=80,servers[0].host=sample,escaped=a\,b
```

The last one will be:

```yaml
a: b
c: d
outer
  inner: value
names:
  - a
	- b
	- c
servers:
  - port: 80
	host: sample
escaped: "a,b"
```

## Upgrading

To ugrade an existing release without creating a new one:

```sh
helm upgrade -f new.yaml test-release-123 bitnami/wordpress
# See the new values
helm get values test-release-123
```

## Rollback a release
```sh
# The number specify the revision number (1 = first release ever)
helm rollback test-release-123 1
```

## Install / Upgrade / Rollback commands

- `--timeout` default to 5m0s, release failed if reached
- `--wait` wait for pods in ready state (with its IP, Ingress if any, etc)
- `--no-hooks` skip running hooks for the command

## Unistall

```sh
helm uninstall test-release-123
# verify it disappeared
helm ls
# If you want to keep the release history
helm uninstall test-release-123 --keep-history
helm ls --uninstalled
helm ls --all # -A
```

## Create a chart
```sh
helm create my-cool-chart
# Lint
helm lint
# Package it (.tgz) when ready
helm package
```