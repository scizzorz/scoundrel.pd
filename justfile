target := "scoundrel"
sedflags := if os() == "macos" { "-i ''" } else { "-i" }

# This is the default recipe when no arguments are provided
[private]
default:
  @just --list --unsorted

# Set flags back to dev
dev-flags:
  sed -e 's/DEMO = true/DEMO = false/' {{sedflags}} src/main.lua
  sed -e 's/RELEASE = true/RELEASE = false/' {{sedflags}} src/main.lua

# Set flags for a demo release
demo-flags:
  sed -e 's/DEMO = false/DEMO = true/' {{sedflags}} src/main.lua
  sed -e 's/RELEASE = false/RELEASE = true/' {{sedflags}} src/main.lua

# Set flags for a prod release
prod-flags:
  sed -e 's/DEMO = true/DEMO = false/' {{sedflags}} src/main.lua
  sed -e 's/RELEASE = false/RELEASE = true/' {{sedflags}} src/main.lua

# Compile everything
build:
  pdc src {{target}}.pdx

# Compile and compress everything
zip: build
  zip {{target}}.pdx.zip -r {{target}}.pdx

# Remove compiled artifacts
clean:
  rm -rf {{target}}.pdx {{target}}.pdx.zip

# Monitor for rebuilds
monitor:
  comma/monitor

# Release a patch version update
patch:
  comma/tag patch

# Release a minor version update
minor:
  comma/tag minor

# Release a major version update
major:
  comma/tag major

# Release a demo build
demo: demo-flags
  git add src
  comma/tag demo

# Release a beta build
beta: prod-flags
  git add src
  comma/tag beta

# Release a catalog build
catalog: prod-flags
  git add src
  comma/tag catalog

# Release an itch build
itch: prod-flags
  git add src
  comma/tag itch
