# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

SafeRun is a Rails 7.2 application for tracking running activities with safety features. Built using the Le Wagon rails-templates. Users can plan runs, track positions during runs, receive badges, and notify guardians (emergency contacts) during their activities.

## Common Commands

```bash
# Start development server
bin/rails server

# Database operations
bin/rails db:migrate
bin/rails db:seed
bin/rails db:reset          # Drop, create, migrate, seed

# Rails console
bin/rails console

# Run tests
bin/rails test
bin/rails test test/models/run_test.rb        # Single file
bin/rails test test/models/run_test.rb:10     # Single test at line

# Asset precompilation (usually automatic)
bin/rails assets:precompile

# Security scan
bundle exec brakeman

# Linting
bundle exec rubocop
```

## Architecture

### Tech Stack
- **Rails 7.2** with PostgreSQL
- **Hotwire**: Turbo + Stimulus for frontend interactivity
- **Importmap**: JavaScript management (no Node.js/Webpack)
- **Bootstrap 5.3** with SCSS via sassc-rails
- **Devise** for authentication
- **Simple Form** for form generation

### Domain Model

```
User
├── has_many :runs
├── has_many :guardians (emergency contacts)
└── has_many :badges (through run_badges)

Run (core entity)
├── belongs_to :user
├── has_many :positions (GPS tracking)
├── has_many :incidents
├── has_many :guardian_notifications
└── has_many :badges (through run_badges)
    Status flow: planned → running → paused → ended

Guardian
├── belongs_to :user
└── has_many :guardian_notifications
```

### Run State Machine
Runs have a status field with transitions:
- `planned` → `running` (start_run action)
- `running` → `paused` (pause_run action)
- `paused` → `running` (resume_run action)
- `running`/`paused` → `ended` (end_run action)

### Stylesheet Organization (Le Wagon convention)
```
app/assets/stylesheets/
├── application.scss        # Main manifest
├── config/                 # Variables, fonts, Bootstrap overrides
├── components/             # Reusable UI components
└── pages/                  # Page-specific styles
```

### Key Routes
- Runs have custom member routes: `start`, `pause`, `resume`, `end`
- Nested resources under runs: `positions`, `run_badges`, `guardian_notifications`
- `/profile` maps to `pages#profile`

## Notes

- App uses French for user-facing messages (notices, alerts)
- PWA support is configured (manifest.json, service-worker)
- All run-related controllers scope queries to `current_user` for authorization
