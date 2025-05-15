
# Dynamic Branch Prediction Simulation

## Problem Definition
This simulation explores the performance of various **dynamic branch prediction schemes** using the `sim-outorder` simulator from the **SimpleScalar toolset**. The goal is to develop a deeper understanding of how different prediction strategies impact processor performance, particularly in relation to control hazards in pipelines.

The processor model used in this assignment mimics a simple, in-order CPU with the following configuration:

- One instruction per cycle: fetch, decode, issue, execute, and commit.
- One functional unit of each type.
- Caches and TLBs configured as:
  - 8KB, 2-way set-associative L1 instruction and data caches (32-byte blocks)
  - 256KB, direct-mapped L2 unified cache (32-byte blocks)
  - 8-way, 128-entry data TLB
  - 4-way, 64-entry instruction TLB
  - LRU block replacement policy
  - 4KB page size

### Branch Prediction Strategies Evaluated

Three prediction schemes are tested and compared:

1. **Static Prediction**:
   - Backward branches are predicted as taken.
   - Forward branches are predicted as not taken.

2. **2-bit Dynamic Branch Prediction**:
   - Uses saturating counters for each branch instruction to dynamically predict future behavior based on past outcomes.

3. **Correlating Branch Prediction**:
   - Employs a global history register and a pattern history table (PHT) to improve prediction by correlating outcomes of recent branches.

### Objective

The simulation aims to analyze and compare these prediction strategies with respect to:

- **Branch frequency and characterization** (forward/backward, taken/not taken)
- **Prediction accuracy** across schemes
- **Impact of history bits** on predictor performance
- **Differences in instruction fetch vs commit counts**
- **Usefulness of traditional static prediction schemes**

Applications from the SPEC95 benchmark suite are used as input, each precompiled for the simulator.

## Problems Encountered and Solutions

### 🛠 Problem 1: Static Branch Prediction Not Available

**Issue:**  
The simulator did not provide a built-in static prediction mode where backward branches are predicted as taken and forward branches as not taken.

**Solution:**  
To implement static prediction, custom logic was added to the `bpred_lookup()` function in `bpred.c`. This logic determines the branch direction based on the comparison between the branch target address and the current instruction address (`btarget < baddr`). If the branch is backward, it is predicted as taken; otherwise, it is predicted as not taken.

```c
if (!(MD_OP_FLAGS(op) & F_CTRL))
    return 0;
    pred->lookups++;
  if (btarget < baddr) {
    dir_update_ptr->dir.bimod = TRUE;
    dir_update_ptr->dir.twolev = TRUE;
    dir_update_ptr->dir.meta = TRUE;
    return btarget;  // Predict taken
  } else {
    dir_update_ptr->dir.bimod = FALSE;
    dir_update_ptr->dir.twolev = FALSE;
    dir_update_ptr->dir.meta = FALSE;
    return baddr + sizeof(md_inst_t);  // Predict not taken
  }
}
### Problem 2: Branch Direction Statistics Not Displayed

**Issue:**

While running simulations in the `sim-outorder` simulator from the SimpleScalar toolset, the output statistics did not include detailed classification of branches. Specifically, there were no counts for:

- Forward branches that were taken or not taken
- Backward branches that were taken or not taken
- Whether these branches were executed or committed

This information is critical for understanding and evaluating the effectiveness of branch prediction strategies.

---

**Solution:**  

To enable the simulator to track and print detailed branch statistics, new counters were added, initialized, updated during simulation, and registered for output in the statistics file.

---

## 🔧 Implementation Steps


#### 1. **Counters Defined**

#### 1. **Counters Defined**

Eight new counters were added to capture branch directions at execution and commit stages:

```c
static counter_t forward_branches_taken;
static counter_t backward_branches_taken;
static counter_t forward_branches_not_taken; 
static counter_t backward_branches_not_taken; 
static counter_t committed_forward_taken;
static counter_t committed_forward_not_taken;
static counter_t committed_backward_taken; 
static counter_t committed_backward_not_taken;
