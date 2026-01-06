# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a distributed banking application built with Gleam, designed as a learning project for Actor model and Event Sourcing patterns. The application implements account management (deposits, withdrawals, transfers) using OTP actors with event sourcing for state management.

## Commands

### Development

```sh
# Run the application (starts HTTP server on port 5000)
gleam run

# Run with auto-reload on file changes
mise run dev

# Run tests
gleam test

# Build the project
gleam build

# Format code
gleam format
```

### Tools

The project uses mise for tool management. Configured tools include:
- Erlang (runtime)
- Gleam (language)
- Rebar (Erlang build tool)
- SQLite (event store)
- Atlas (database migrations)
- Docker Compose (for future distributed deployment)

## Architecture

### Core Concepts

This application combines three architectural patterns:

1. **Actor Model**: Each account is managed by an independent OTP actor with its own mailbox
2. **Event Sourcing**: All state changes are persisted as immutable events
3. **CQRS**: Separation between command handling (actors) and event storage

### System Structure

```
HTTP API (Wisp/Mist)
    ↓ process.call()
Account Registry Actor
    ↓
Multiple Account Actors (one per account)
    ↓
Event Store (SQLite)
```

### Key Modules

- `src/app.gleam`: Application entry point, starts the Mist HTTP server on port 5000
- `src/app/routes.gleam`: HTTP routing and request handling
- `src/features/account/model.gleam`: Core type definitions for events, messages, and state
- `src/features/account/actor.gleam`: Account actor implementation (in progress)
- `src/features/account/registry.gleam`: Registry actor for account lookup (planned)
- `src/features/account/handler.gleam`: HTTP handlers for account endpoints (planned)

### Event Types

All account operations are modeled as events:
- `AccountOpened`: Initial account creation with opening balance
- `MoneyDeposited`: Credit transaction
- `MoneyWithdrawn`: Debit transaction
- `TransferSent` / `TransferReceived`: Inter-account transfers

### Actor Communication

Actors communicate via `process.call()` for synchronous request-response patterns:
- HTTP layer uses `process.call()` to interact with actors
- Actors respond via `Subject` channels
- Each account actor maintains its own state rebuilt from events

## Project Phases

The project follows a phased approach (see docs/plan.md for details):

1. **Phase 1**: Basic actor + HTTP API (single account operations)
2. **Phase 2**: Event sourcing (event persistence and replay)
3. **Phase 3**: Multiple accounts + transfers (inter-actor communication)
4. **Phase 4**: Supervisors (fault tolerance)
5. **Phase 5**: Distribution (multi-node deployment)

Current status: **Phase 1** - implementing basic Account actor

## Important Patterns

### Actor State Management

Actors maintain in-memory state (balance, events list) reconstructed from events. State is ephemeral - persistence happens through the event store.

### Concurrency Model

- Each account = one actor = one mailbox = automatic serialization of operations
- Operations on different accounts are fully concurrent
- No manual locking or mutex needed - the actor mailbox provides ordering guarantees

### HTTP to Actor Bridge

The HTTP layer (Wisp) is synchronous, while actors are asynchronous. Use `process.call()` to bridge:
- Client sends HTTP request
- Handler calls actor via `process.call()`
- Actor processes message and replies via `Subject`
- Handler returns HTTP response

## Testing

Tests use gleeunit framework. Test files end in `_test.gleam` and test functions end in `_test`.

```sh
# Run all tests
gleam test
```

## Dependencies

Core dependencies:
- `wisp`: Web framework for HTTP handling
- `mist`: HTTP server
- `gleam_otp`: OTP abstractions (actors, supervisors)
- `gleam_erlang`: Erlang interop
- `sqlight`: SQLite bindings for event store
- `gleam_http`: HTTP types
- `gleam_json`: JSON encoding/decoding

## Development Notes

### Adding New Event Types

1. Add event variant to `AccountEvent` type in `src/features/account/model.gleam`
2. Implement event application logic in actor's `apply()` function
3. Update event replay logic in `replay()` function

### Adding New Actor Messages

1. Add message variant to `AccountMessage` type in `src/features/account/model.gleam`
2. Implement message handler in account actor
3. Update HTTP handler to call the new message

### Registry Pattern

The Registry actor maintains a `Dict(String, Subject(AccountMessage))` mapping account IDs to actor subjects. It handles:
- Account creation (spawning new actors)
- Account lookup (finding existing actors by ID)
- Dynamic actor lifecycle (creation on-demand)

### MUST
コーチングに徹すること

