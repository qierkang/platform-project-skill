#!/usr/bin/env bash
set -euo pipefail

PROJECT_PATH="${1:-}"

if [[ -z "$PROJECT_PATH" ]]; then
  echo "usage: inspect-project.sh <project-path>" >&2
  exit 2
fi

if [[ ! -d "$PROJECT_PATH" ]]; then
  echo "PROJECT_EXISTS=0"
  echo "PROJECT_TYPE=missing"
  exit 0
fi

file_count="$(find "$PROJECT_PATH" -mindepth 1 -maxdepth 3 -type f 2>/dev/null | wc -l | tr -d ' ')"
dir_count="$(find "$PROJECT_PATH" -mindepth 1 -maxdepth 2 -type d 2>/dev/null | wc -l | tr -d ' ')"

has_git=0
has_readme=0
has_agents=0
has_claude=0
has_assets=0
has_docs=0
has_graphify=0
has_package=0
has_pom=0
has_gradle=0
has_docker=0

[[ -d "$PROJECT_PATH/.git" ]] && has_git=1
[[ -f "$PROJECT_PATH/README.md" ]] && has_readme=1
[[ -f "$PROJECT_PATH/AGENTS.md" ]] && has_agents=1
[[ -f "$PROJECT_PATH/CLAUDE.md" || -f "$PROJECT_PATH/.claude/CLAUDE.md" ]] && has_claude=1
[[ -d "$PROJECT_PATH/assets" ]] && has_assets=1
[[ -d "$PROJECT_PATH/docs" ]] && has_docs=1
[[ -f "$PROJECT_PATH/graphify-out/GRAPH_REPORT.md" ]] && has_graphify=1
[[ -f "$PROJECT_PATH/package.json" || -n "$(find "$PROJECT_PATH" -maxdepth 3 -name package.json -print -quit 2>/dev/null)" ]] && has_package=1
[[ -f "$PROJECT_PATH/pom.xml" || -n "$(find "$PROJECT_PATH" -maxdepth 3 -name pom.xml -print -quit 2>/dev/null)" ]] && has_pom=1
[[ -f "$PROJECT_PATH/build.gradle" || -f "$PROJECT_PATH/settings.gradle" || -n "$(find "$PROJECT_PATH" -maxdepth 3 -name build.gradle -print -quit 2>/dev/null)" ]] && has_gradle=1
[[ -f "$PROJECT_PATH/docker-compose.yml" || -f "$PROJECT_PATH/Dockerfile" || -n "$(find "$PROJECT_PATH" -maxdepth 3 -name Dockerfile -print -quit 2>/dev/null)" ]] && has_docker=1

project_type="existing"
if [[ "$file_count" -eq 0 ]]; then
  project_type="new-empty"
elif [[ "$file_count" -lt 8 && "$has_git" -eq 0 && "$has_package" -eq 0 && "$has_pom" -eq 0 && "$has_gradle" -eq 0 ]]; then
  project_type="new-light"
fi

echo "PROJECT_EXISTS=1"
echo "PROJECT_TYPE=$project_type"
echo "FILE_COUNT=$file_count"
echo "DIR_COUNT=$dir_count"
echo "HAS_GIT=$has_git"
echo "HAS_README=$has_readme"
echo "HAS_AGENTS=$has_agents"
echo "HAS_CLAUDE=$has_claude"
echo "HAS_ASSETS=$has_assets"
echo "HAS_DOCS=$has_docs"
echo "HAS_GRAPHIFY=$has_graphify"
echo "HAS_PACKAGE_JSON=$has_package"
echo "HAS_MAVEN=$has_pom"
echo "HAS_GRADLE=$has_gradle"
echo "HAS_DOCKER=$has_docker"

