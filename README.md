# Problem statement

After a disaster servers are recovering with possibly corrupted disks on the same hardware.
They restart with the same binary in a trusted env.

# Current DR procedure
1 mile up view:
- Restart each node's cchost in recovery
  - reads ledger
  - Starts 1 node public network
- Choose which node to use for recovery, that network is now the 'canonical' network
- Update configuration of canonical network as normal

# Aim
- Assuming restarting nodes on the same cpus use the ledgers to recover
- Leave the network in a state that either:
  - Has a primary and can start the steady state
  - The configuration is 'valid' but leaderless so requires a CCFRaft election to start

## Complications

- Deployment must be identical for the derived key to work
  - So HostData must be the same
  - So we need identical start commands
  - So the ccf node must check for recovery on startup
  - Or we add a wrapper for PF-CI that figures out whether to recover or not

- The cluster might be suboptimal
  - Not all replicas might be recoverable (non-majority worst case)
  - incomplete (corrupted) ledger files
    - Possibly rolled back
    - Possible patchy
  - Mid reconfiguration
  - Mid DR 

# Steps every protocol is likely to take

- Local recovery
  - Unseal and validate ledger
  - Read current active configurations
- Discovery round
  - Contact nodes with a digest of log.
  - Learn of successful recovery attempts
  - Bc not all nodes will restart simultaneously, will probably have to take a while
- Choose a recovery candidate
  - Raft Majority
- Ledger recovery
  - Gossip to choose and fixup ledgers
  - Collect the 'best' ledger on 

# L0 DR
Assume:
- Majority recovery
- 'up to date' ledgers

# L1 DR
Assume
- Knowably faulty ledger (validation fails)

This means some nodes will have missing or corrupted ledgers, and simple candidate style elections will fail.

# Nuts and bolts

- Need configuration / status discovery