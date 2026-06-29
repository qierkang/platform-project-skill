# Omni Platform

<div align="center">
  <strong>Reusable platform project baseline with split clients, Docker orchestration, layered documentation, and bilingual visual assets.</strong>
</div>

<div align="center">

[简体中文](../README.md) · **English**

</div>

## Overview

`Omni Platform` is a reusable baseline for admin, mobile, and server applications. The default root README is Simplified Chinese. This English document uses the matching English image set.

## Architecture

![Platform architecture](../assets/platform/architecture/en/omni-platform-overview.png)

![Platform design baseline](../assets/platform/design/en/omni-platform-design-baseline.png)

## Interface Concepts

![Admin UI design draft](../assets/omni-platform-front/design/en/front-ui-design-draft.png)

![Admin dashboard concept](../assets/omni-platform-front/screenshots/en/front-dashboard-concept.png)

![Mobile UI design draft](../assets/omni-platform-mobile/design/en/mobile-ui-design-draft.png)

![Mobile home concept](../assets/omni-platform-mobile/screenshots/en/mobile-home-concept.png)

## Server

![Server architecture](../assets/omni-platform-server/architecture/en/server-architecture-concept.png)

## Project Structure

```text
.
├── assets/
├── docs/
├── omni-platform-front/
├── omni-platform-mobile/
├── omni-platform-server/
├── scripts/
└── docker-compose.yml
```

## Quick Start

```bash
pnpm install:all
docker compose up -d --build
```

Default endpoints:

- Admin: `http://127.0.0.1:7061`
- Mobile: `http://127.0.0.1:7062`
- API: `http://127.0.0.1:7060`

## Validation

```bash
pnpm build
docker compose config -q
```

## Author

- `xyqierkang@gmail.com`
- [github.com/qierkang](https://github.com/qierkang)
