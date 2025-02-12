---- MODULE CCF_DR_concrete ----

EXTENDS Integers, FiniteSets

Range(F) == {F[k] : k \in DOMAIN F}

CONSTANTS 
  NodeIDs,
  TXNs

VARIABLES
  ledger

LedgerTxnTypeOk(e) ==
  /\ e.type = "txn"
  /\ e.txn \in TXNs

LedgerConfigTypeOk(e) ==
  /\ e.type = "config"
  /\ e.config \subset NodeIDs

LedgerTypeOk ==
  \A n \in NodeIDs:
  /\ DOMAIN ledger[n] \subseteq Nat
  /\ \A e \in Range(ledger[n]): 
     \/ LedgerTxnTypeOk(e)
     \/ LedgerConfigTypeOk(e)

ContiguousLedger(n) ==
LET idxs == DOMAIN ledger[n]
    max_idx == CHOOSE idx \in idxs: \A idx2 \in idxs: idx2 <= idx
IN idxs = 1..max_idx

PossibleCCFRaftLedgers ==
  /\ LedgerTypeOk
  /\ \A n \in NodeIDs: ContiguousLedger(n) \* Can loosen later 

\* This might not work from an instantiation perspective but is the right direction
Init ==
  /\ PossibleCCFRaftLedgers

====