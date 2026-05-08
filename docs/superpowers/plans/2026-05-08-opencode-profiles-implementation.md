# OpenCode Home/Work MCP Split Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Split OpenCode MCP configuration into base + profile overlays so home keeps `megaten_fusion` and work uses Atlassian MCP.

**Architecture:** Keep shared OpenCode settings in `userConfigurations/kreato/opencode.nix`, then move profile-specific MCP entries into existing `systemName`-gated overlays in `userConfigurations/kreato/modules/home.nix` and `userConfigurations/kreato/modules/work.nix`. Validate using Nix eval for both `work` and `akiri` hosts.

**Tech Stack:** Nix flakes, nix-darwin, Home Manager module merging, OpenCode MCP settings.

---

### Task 1: Move Megaten MCP out of base module

**Files:**
- Modify: `userConfigurations/kreato/opencode.nix`
- Test: `userConfigurations/kreato/opencode.nix` (Nix parse via eval in Task 4)

- [ ] **Step 1: Write the failing check (precondition capture)**

Run:

```bash
nix eval --impure --expr 'let flake = builtins.getFlake (toString ./.); in flake.darwinConfigurations.work.config."home-manager".users.kreato.programs.opencode.settings.mcp.megaten_fusion.enabled'
```

Expected: `true` (current undesired state for work profile).

- [ ] **Step 2: Remove `megaten_fusion` from base `settings.mcp`**

Edit `userConfigurations/kreato/opencode.nix` so `settings.mcp` keeps only shared entries:

```nix
      mcp = {
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
        };
        gh_grep = {
          type = "remote";
          url = "https://mcp.grep.app";
        };
        exa = {
          type = "remote";
          url = "https://mcp.exa.ai/mcp";
          enabled = true;
        };
      };
```

- [ ] **Step 3: Run formatting-aware sanity check**

Run:

```bash
nix eval --impure --expr 'let flake = builtins.getFlake (toString ./.); in builtins.hasAttr "mcp" flake.darwinConfigurations.work.config."home-manager".users.kreato.programs.opencode.settings'
```

Expected: `true`.

- [ ] **Step 4: Commit Task 1 changes**

```bash
git add userConfigurations/kreato/opencode.nix
git commit -m "refactor(opencode): keep only shared MCP entries in base module"
```

### Task 2: Add home overlay MCP (`megaten_fusion`)

**Files:**
- Modify: `userConfigurations/kreato/modules/home.nix`
- Test: `userConfigurations/kreato/modules/home.nix` (Nix eval in Task 4)

- [ ] **Step 1: Write the failing check (home currently lacks explicit overlay ownership)**

Run:

```bash
nix eval --impure --expr 'let flake = builtins.getFlake (toString ./.); in builtins.hasAttr "megaten_fusion" flake.darwinConfigurations.akiri.config."home-manager".users.kreato.programs.opencode.settings.mcp'
```

Expected after Task 1 and before this task: likely `false`.

- [ ] **Step 2: Add `megaten_fusion` MCP block to home overlay**

In `userConfigurations/kreato/modules/home.nix`, inside `config = lib.mkIf (systemName != "work") { ... };`, add:

```nix
    programs.opencode.settings.mcp.megaten_fusion = {
      type = "local";
      command = [
        "bun"
        "x"
        "megaten-fusion-mcp"
      ];
      enabled = true;
    };
```

- [ ] **Step 3: Verify home host now has Megaten MCP**

Run:

```bash
nix eval --impure --expr 'let flake = builtins.getFlake (toString ./.); in flake.darwinConfigurations.akiri.config."home-manager".users.kreato.programs.opencode.settings.mcp.megaten_fusion.enabled'
```

Expected: `true`.

- [ ] **Step 4: Commit Task 2 changes**

```bash
git add userConfigurations/kreato/modules/home.nix
git commit -m "feat(opencode): define megaten MCP in home overlay"
```

### Task 3: Add work overlay MCP (Atlassian) and disable Megaten in work

**Files:**
- Modify: `userConfigurations/kreato/modules/work.nix`
- Test: `userConfigurations/kreato/modules/work.nix` (Nix eval in Task 4)

- [ ] **Step 1: Write failing checks for work profile targets**

Run:

```bash
nix eval --impure --expr 'let flake = builtins.getFlake (toString ./.); in builtins.hasAttr "atlassian" flake.darwinConfigurations.work.config."home-manager".users.kreato.programs.opencode.settings.mcp'
```

Expected: `false`.

Run:

```bash
nix eval --impure --expr 'let flake = builtins.getFlake (toString ./.); in flake.darwinConfigurations.work.config."home-manager".users.kreato.programs.opencode.settings.mcp.megaten_fusion.enabled'
```

Expected before this task: `true` or attribute exists.

- [ ] **Step 2: Add Atlassian MCP block in work overlay**

In `userConfigurations/kreato/modules/work.nix`, inside `config = lib.mkIf (systemName == "work") { ... };`, add:

```nix
    programs.opencode.settings.mcp.atlassian = {
      type = "remote";
      url = "https://mcp.atlassian.com/v1/mcp/authv2";
      enabled = true;
    };
```

- [ ] **Step 3: Force-disable Megaten MCP in work overlay**

In the same work overlay block, add:

```nix
    programs.opencode.settings.mcp.megaten_fusion.enabled = lib.mkForce false;
```

- [ ] **Step 4: Verify work overlay behavior**

Run:

```bash
nix eval --impure --expr 'let flake = builtins.getFlake (toString ./.); in flake.darwinConfigurations.work.config."home-manager".users.kreato.programs.opencode.settings.mcp.atlassian.url'
```

Expected: `"https://mcp.atlassian.com/v1/mcp/authv2"`.

Run:

```bash
nix eval --impure --expr 'let flake = builtins.getFlake (toString ./.); in flake.darwinConfigurations.work.config."home-manager".users.kreato.programs.opencode.settings.mcp.megaten_fusion.enabled'
```

Expected: `false`.

- [ ] **Step 5: Commit Task 3 changes**

```bash
git add userConfigurations/kreato/modules/work.nix
git commit -m "feat(opencode): add work Atlassian MCP and disable megaten"
```

### Task 4: Full profile verification and final commit

**Files:**
- Modify: none (verification only unless fixes needed)
- Test: `flake.nix`, `userConfigurations/kreato/opencode.nix`, `userConfigurations/kreato/modules/home.nix`, `userConfigurations/kreato/modules/work.nix`

- [ ] **Step 1: Evaluate work darwin configuration**

Run:

```bash
darwin-rebuild build --flake .#work
```

Expected: build/evaluation succeeds with no option/type errors.

- [ ] **Step 2: Evaluate home darwin configuration**

Run:

```bash
darwin-rebuild build --flake .#akiri
```

Expected: build/evaluation succeeds with no option/type errors.

- [ ] **Step 3: Verify MCP state in both profiles**

Run:

```bash
nix eval --impure --expr 'let flake = builtins.getFlake (toString ./.); in {
  workAtlassian = flake.darwinConfigurations.work.config."home-manager".users.kreato.programs.opencode.settings.mcp.atlassian.url;
  workMegaten = flake.darwinConfigurations.work.config."home-manager".users.kreato.programs.opencode.settings.mcp.megaten_fusion.enabled;
  homeMegaten = flake.darwinConfigurations.akiri.config."home-manager".users.kreato.programs.opencode.settings.mcp.megaten_fusion.enabled;
}'
```

Expected:
- `workAtlassian = "https://mcp.atlassian.com/v1/mcp/authv2"`
- `workMegaten = false`
- `homeMegaten = true`

- [ ] **Step 4: Final commit (if verification required fixups, include them)**

```bash
git add userConfigurations/kreato/opencode.nix userConfigurations/kreato/modules/home.nix userConfigurations/kreato/modules/work.nix
git commit -m "feat(opencode): split MCP config by home and work profiles"
```

- [ ] **Step 5: Post-change runtime smoke checks**

Run manually on each host after switch/rebuild:

```bash
opencode
```

Expected:
- Work host shows Atlassian MCP and Megaten disabled.
- Home host shows Megaten MCP available.

## Self-Review Checklist (completed)

- Spec coverage: all approved sections mapped to tasks (architecture split, boundaries, edge-case guard, verification).
- Placeholder scan: no TODO/TBD or implicit "do appropriate X" steps remain.
- Type consistency: all paths and option names use `programs.opencode.settings.mcp.<name>` consistently across tasks.
