# 🕯️ candela-protos

Canonical Protocol Buffer definitions for the [Candela](https://github.com/candelahq/candela) platform.

Published to the [Buf Schema Registry](https://buf.build/candelahq/protos) for dependency resolution and remote code generation.

## Quick start

```bash
# Enter the Nix dev shell (provides buf, protoc, lefthook, etc.)
nix develop

# Lint
buf lint

# Format check
buf format --diff

# Build (verify all protos compile)
buf build
```

## Repository layout

```
.
├── buf.yaml              # Module config (buf.build/candelahq/protos)
├── candela/
│   ├── types/            # Shared message types
│   │   ├── annotation.proto  # Annotation
│   │   ├── common.proto      # Pagination, TimeRange, Attribute
│   │   ├── model_catalog.proto # ModelCatalogEntry
│   │   ├── trace.proto       # Span, Trace, TraceSummary
│   │   ├── user.proto        # User, UserBudget, BudgetGrant, AuditEntry
│   │   ├── project.proto     # Project, APIKey
│   │   └── bq_span.proto     # BqSpanRow (BigQuery projection)
│   └── v1/               # Service definitions (ConnectRPC / gRPC)
│       ├── annotation_service.proto
│       ├── ingestion_service.proto
│       ├── model_catalog_service.proto
│       ├── runtime_service.proto
│       ├── dashboard_service.proto
│       ├── trace_service.proto
│       ├── project_service.proto
│       └── user_service.proto
├── flake.nix             # Nix dev shell
├── lefthook.yml          # Pre-commit hooks
└── .github/workflows/
    └── ci.yml            # Buf lint, format, breaking change detection
```

## Dependencies

| Module | Purpose |
|---|---|
| [`buf.build/bufbuild/protovalidate`](https://buf.build/bufbuild/protovalidate) | Declarative field validation (CEL) |
| [`buf.build/googlecloudplatform/bq-schema-api`](https://buf.build/googlecloudplatform/bq-schema-api) | BigQuery schema annotations |

## Consuming these protos

### As a Buf dependency

Add to your `buf.yaml`:

```yaml
deps:
  - buf.build/candelahq/protos
```

Then import:

```protobuf
import "candela/types/trace.proto";
import "candela/v1/trace_service.proto";
```

### Remote code generation (BSR)

Consumers can use BSR's remote generation instead of running `buf generate` locally.
See the [BSR documentation](https://buf.build/docs/bsr/remote-generation/overview) for details.

## Publishing

Publishing to BSR is automated via CI on semver tags:

```bash
# Tag and push — CI publishes to buf.build/candelahq/protos
git tag v0.6.0
git push --tags
```

The CI workflow runs lint → format → breaking check, then `buf push --label v0.6.0`.
Requires `BUF_TOKEN` repository secret (configured).

## License

Apache 2.0
