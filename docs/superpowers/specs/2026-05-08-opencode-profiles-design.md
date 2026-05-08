# OpenCode Home/Work Profile Split Design

## Context

Current OpenCode configuration lives in `userConfigurations/kreato/opencode.nix` and includes shared settings plus MCP server definitions. The goal is to align OpenCode with the repository's existing host/work split pattern: one base config, one work-specific overlay.

## Goals

- Keep one shared OpenCode base module for common settings.
- Configure `megaten_fusion` for home (non-work) profile.
- Configure Atlassian MCP (`https://mcp.atlassian.com/v1/mcp/authv2`) for work profile.
- Avoid duplication of full OpenCode config blocks.

## Non-goals

- Changing provider/model/plugin behavior unrelated to profile splitting.
- Introducing a new profile selection mechanism.
- Reworking host import topology.

## Proposed Architecture

Use a base + overlay split:

1. Base module: `userConfigurations/kreato/opencode.nix`
   - Own shared `programs.opencode` settings.
   - Keep global MCP entries that apply everywhere (`context7`, `gh_grep`, `exa`).
   - Do not keep profile-specific MCP servers in base.

2. Home overlay: `userConfigurations/kreato/modules/home.nix`
   - Under `lib.mkIf (systemName != "work")`, define/enable `programs.opencode.settings.mcp.megaten_fusion`.

3. Work overlay: `userConfigurations/kreato/modules/work.nix`
   - Under `lib.mkIf (systemName == "work")`, define/enable `programs.opencode.settings.mcp.atlassian` as a remote MCP server with URL `https://mcp.atlassian.com/v1/mcp/authv2`.
   - Ensure `megaten_fusion` is disabled or absent in work output.

## Configuration Boundaries

- `main.nix` already imports:
  - `./opencode.nix`
  - `./modules/work.nix`
  - `./modules/home.nix`
- Existing `systemName`-gated overlays remain the only selector mechanism.
- Nix option merging yields final per-host MCP sets.

## Error Handling and Edge Cases

- Avoid duplicate definitions for the same MCP key across base/home/work unless explicit override is intended.
- In work overlay, force-disable `megaten_fusion` if needed to guard against future accidental inheritance.
- Keep Atlassian MCP block minimal (`type`, `url`, `enabled`) unless additional auth config becomes required.
- Preserve behavior for non-work hosts apart from relocating `megaten_fusion` ownership from base to home overlay.

## Verification Plan

1. Evaluate both profiles:
   - `darwin-rebuild build --flake .#work`
   - `darwin-rebuild build --flake .#akiri` (or whichever non-work host you use)
2. Inspect generated OpenCode config for each profile:
   - Work: Atlassian MCP present; `megaten_fusion` not active.
   - Home: `megaten_fusion` present; Atlassian absent unless intentionally shared later.
3. Run runtime smoke check:
   - Start OpenCode and confirm MCP list matches host profile.

## Implementation Notes

- Prefer moving the full `megaten_fusion` block from base into home overlay for clarity.
- Keep overlay deltas small and profile-specific to reduce long-term drift.
