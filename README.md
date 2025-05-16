## Table of Contents
- [Course Name](#course-name)
- [Acknowledgement](#acknowlegment)
- [Team Members](#team-members)
- [Problem Definition](#dynamic-branch-prediction-simulation)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Problems Encountered and solution](#Problems-Encountered-and-Solutions)
- [Commands And Parameters Used](#command-used)
- [Sample Output](#sample-output)  

## Course Name 
**ECE322C Computer Architecture**

## Acknowledgment
This project was carried out under the supervision of **Dr. May Mohamed**, whose insightful feedback and constant encouragement were greatly appreciated.

## Team Members 
1. **Abdelrahman Wahid Abdallah** 
2. **Abdelrahman Mamdouh Mohamed** 
3. **Ahmed Ragab**
4. **Aya Mohamed Sayed** 
5. **Shams Hesham** 

## Dynamic Branch Prediction Simulation

### Problem-Definition

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

## Prerequisites

- Unix-like operating system (Linux/macOS)
- SimpleScalar base installation
- GCC version 2.7.2.3 (SimpleScalar-specific)
- Basic knowledge of cross-compilation concepts
  
---

## Installation

### 1. Download the SimpleScalar toolset:

```bash
git clone https://github.com/Abdo5200/Simple-Scalar
cd simplesim-3.0
```
### 2. Build the simulator:

```bash
make clean
make
```

### 3. Build the toolchain:

```bash 
cd ../gcc-2.7.2.3
./configure --host=$HOST --target=sslittle-na-sstrix --with-gnu-as --with-gnu-ld --prefix=$INSTALL_DIR
make
make install
```

## Problems-Encountered-and-Solutions

### Problem 1: Architecture Compatibility Issues

**Issue:**  
SimpleScalar was developed for 32-bit systems and can face compatibility issues on 64-bit environments.

**Solution**
### 1. Install 32-bit libraries

`Debian/Ubuntu:`

```bash 
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386
```

`Fedora/RHEL/CentOS:`

```bash
sudo dnf install glibc.i686 libstdc++.i686 ncurses-libs.i686
```

### 2. Use multilib compiler flags:

```bash
CFLAGS="-m32" LDFLAGS="-m32" ./configure --host=i386-linux ...
```
### 3. Create a 32-bit Docker environment:

```bash
docker pull i386/ubuntu:18.04
docker run -it -v /path/to/simplescalar:/simplescalar i386/ubuntu:18.04
```
### 4. Modify SimpleScalar Makefiles:
Add the following to the Makefile if needed:

``` bash 
CFLAGS += -m32
LDFLAGS += -m32
```

### 5. Use compatibility flag when running tools:

``` bash 
linux32 /path/to/simplescalar/bin/sslittle-na-sstrix-gcc ...
```

### 6. Configure Environment Setup
Add the following to your ~/.bashrc or ~/.zshrc:

```bash
# SimpleScalar paths
export SIMPLESCALAR_HOME=/path/to/simplescalar
export PATH=$SIMPLESCALAR_HOME/bin:$PATH

# Force 32-bit mode
alias ssgcc="linux32 $SIMPLESCALAR_HOME/bin/sslittle-na-sstrix-gcc"
alias ssas="linux32 $SIMPLESCALAR_HOME/bin/sslittle-na-sstrix-as"
alias ssld="linux32 $SIMPLESCALAR_HOME/bin/sslittle-na-sstrix-ld"
```

### 7. Create symbolic link for the assembler:

```bash
ln -s $SIMPLESCALAR_HOME/bin/sslittle-na-sstrix-as $SIMPLESCALAR_HOME/lib/gcc-lib/sslittle-na-sstrix/2.7.2.3/as
```

### 8. Create a compilation Script file ~/compile-for-ss.sh:

```bash
#!/bin/bash

# Usage: ~/compile-for-ss.sh source.c [output_executable]

if [ $# -lt 1 ]; then
    echo "Usage: $0 source.c [output_executable]"
    exit 1
fi

SOURCE=$1
BASE_NAME=$(basename $SOURCE .c)
OUTPUT=${2:-$BASE_NAME}

SS_HOME=/path/to/simplescalar
SS_BIN=$SS_HOME/bin
SS_LIB=$SS_HOME/lib
GCC_LIB=$SS_HOME/lib/gcc-lib/sslittle-na-sstrix/2.7.2.3

LINUX32=""
if [ "$(uname -m)" = "x86_64" ]; then
    which linux32 > /dev/null
    if [ $? -eq 0 ]; then
        LINUX32="linux32"
        echo "64-bit system detected, using linux32 for compatibility"
    else
        echo "Warning: 'linux32' not found"
    fi
fi

echo "Compiling $SOURCE to assembly..."
$LINUX32 $SS_BIN/sslittle-na-sstrix-gcc -S $SOURCE -o $BASE_NAME.s || exit 1

echo "Assembling to object file..."
$LINUX32 $SS_BIN/sslittle-na-sstrix-as $BASE_NAME.s -o $BASE_NAME.o || exit 1

echo "Linking object file to executable..."
$LINUX32 $SS_BIN/sslittle-na-sstrix-ld \
    -dynamic-linker /lib/ld-linux.so.2 \
    $GCC_LIB/crt0.o $BASE_NAME.o \
    -L$GCC_LIB -L$SS_LIB -lgcc -lc -lm \
    -o $OUTPUT || {
        echo "Standard linking failed, trying alternative approach..."
        $LINUX32 $SS_BIN/sslittle-na-sstrix-gcc $BASE_NAME.o \
            -L$GCC_LIB -L$SS_LIB \
            $GCC_LIB/libgcc.a \
            -o $OUTPUT || exit 1
    }

echo "Successfully compiled $SOURCE to $OUTPUT"
```

### 9. Make the compile script file executable:

```bash
chmod +x ~/compile-for-ss.sh
```
### 10. Error: `Wrong ELF class: ELFCLASS64`

```bash
sudo apt-get install gcc-multilib libc6:i386
linux32 $SIMPLESCALAR_HOME/bin/sslittle-na-sstrix-gcc hello.c -o hello
```
### 11. Error: `Cannot execute binary file: Exec format error`

```bash
file $SIMPLESCALAR_HOME/bin/sslittle-na-sstrix-gcc
sudo apt-get install libc6-i386
```
### 12. Missing `cc1`

```bash
ls -la $SIMPLESCALAR_HOME/lib/gcc-lib/sslittle-na-sstrix/2.7.2.3/
ln -s $SIMPLESCALAR_HOME/lib/gcc-lib/sslittle-na-sstrix/2.7.2.3/cc1 $SIMPLESCALAR_HOME/bin/
``` 
### 13. Incorrect `include/library paths`

```bash
export C_INCLUDE_PATH=$SIMPLESCALAR_HOME/include:$C_INCLUDE_PATH
export LIBRARY_PATH=$SIMPLESCALAR_HOME/lib:$LIBRARY_PATH
```

### 14. Assembler Problem with -EL

Create a wrapper script ss-as-wrapper.sh:

```bash
#!/bin/bash
$SIMPLESCALAR_HOME/bin/sslittle-na-sstrix-as $(echo "$@" | sed 's/-EL//g')
```

### 15. Make it executable

```bash
chmod +x ss-as-wrapper.sh
MIPS pseudo-operations not recognized:
```
### 16. Linker Issues Missing libraries

```bash
$SIMPLESCALAR_HOME/bin/sslittle-na-sstrix-ld \
    input.o \
    $SIMPLESCALAR_HOME/lib/gcc-lib/sslittle-na-sstrix/2.7.2.3/libgcc.a \
    -o output_executable
``` 
### 17. Undefined references:
```bash
$SIMPLESCALAR_HOME/bin/sslittle-na-sstrix-gcc \
    input.o \
    -L$SIMPLESCALAR_HOME/lib/gcc-lib/sslittle-na-sstrix/2.7.2.3 \
    -L$SIMPLESCALAR_HOME/lib \
    -lgcc -lc -lm \
    -o output_executable
``` 

## 🛠 Problem 2: Static Branch Prediction Not Available

**Issue:**  
The simulator did not provide a built-in static prediction mode where backward branches are predicted as taken and forward branches as not taken.

**Solution:**  
To implement this manually, I modified the `bpred_lookup()` function inside `bpred.c`. I added a condition to check the predictor class (`BPredStatic`) and used the branch target (`btarget`) compared to the branch address (`baddr`) to determine the direction of the branch.

If the branch was backward (`btarget < baddr`), it was predicted as taken; otherwise, as not taken. The prediction result was also assigned to the `dir_update_ptr` fields for accurate tracking.

This custom logic allowed static prediction to work as expected when selected in the simulator configuration.

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
```
## 🛠 Problem 3: Branch Direction Statistics Not Displayed

**Issue:**  
The simulator did not display detailed statistics for forward and backward branches—specifically, how many were taken or not taken during both execution and commit stages. These metrics were essential for analyzing branch behavior in relation to prediction strategies.

**Solution:**  
To collect and report these statistics, the following steps were taken inside the file `sim-outorder.c` :

#### 1. **Counters Defined**

Eight new counters were added to track forward/backward branches and their taken/not taken states, both during execution and commit:

```c
static counter_t forward_branches_taken;
static counter_t backward_branches_taken;
static counter_t forward_branches_not_taken; 
static counter_t backward_branches_not_taken; 
static counter_t committed_forward_taken;
static counter_t committed_forward_not_taken;
static counter_t committed_backward_taken; 
static counter_t committed_backward_not_taken;
```
### 2. Counters Initialized

All counters were initialized in `lsq_init()`:

```c
forward_branches_taken = 0;
forward_branches_not_taken = 0; 
backward_branches_taken = 0; 
backward_branches_not_taken = 0; 
committed_forward_taken = 0; 
committed_forward_not_taken = 0; 
committed_backward_taken = 0; 
committed_backward_not_taken = 0;
```
### 3. Counting During Execution

by comparing `target_PC` to `regs.regs_PC` to detect forward vs. backward branches.

```c
if (MD_OP_FLAGS(op) & F_CTRL) {
  sim_total_branches++;
  if (target_PC > regs.regs_PC) {
    if (br_taken)
     forward_branches_taken++;
    else
     forward_branches_not_taken++;
  } else if (target_PC < regs.regs_PC) {
    if (br_taken)
     backward_branches_taken++;
    else
     backward_branches_not_taken++;
  }
}
```
### 4. Counting During Commit

Similarly, committed branch directions were recorded when instructions were finalized:

```c
if (MD_OP_FLAGS(op) & F_CTRL) {
  sim_num_branches++;
  if (target_PC > regs.regs_PC) {
    if (br_taken)
     committed_forward_taken++;
    else
     committed_forward_not_taken++;
  } else if (target_PC < regs.regs_PC) {
    if (br_taken)
     committed_backward_taken++;
    else
     committed_backward_not_taken++;
  }
}
```
### 5. Registering Statistics

Finally, the counters were registered for output in the statistics report using `stat_reg_counter()`:

```c
stat_reg_counter(sdb, "forward_taken", "number of forward branches that were taken", &forward_branches_taken, 0, NULL);
stat_reg_counter(sdb, "forward_not_taken", "number of forward branches that were not taken", &forward_branches_not_taken, 0, NULL);
stat_reg_counter(sdb, "backward_taken", "number of backward branches that were taken", &backward_branches_taken, 0, NULL);
stat_reg_counter(sdb, "backward_not_taken", "number of backward branches that were not taken", &backward_branches_not_taken, 0, NULL);
stat_reg_counter(sdb, "committed_forward_taken", "number of committed forward branches that were taken", &committed_forward_taken, 0, NULL);
stat_reg_counter(sdb, "committed_forward_not_taken", "number of committed forward branches that were not taken", &committed_forward_not_taken, 0, NULL);
stat_reg_counter(sdb, "committed_backward_taken", "number of committed backward branches that were taken", &committed_backward_taken, 0, NULL);
stat_reg_counter(sdb, "committed_backward_not_taken", "number of committed backward branches that were not taken", &committed_backward_not_taken, 0, NULL);
```

## Command Used 

```bash
./sim-outorder -fetch:ifqsize 1 -decode:width 1 -issue:width 1 -issue:inorder true -res:ialu 1 -res:imult 1 -res:memport 1 -res:fpalu 1 -res:fpmult 1 -bpred <`predictor type`> -cache:dl1 dl1:128:32:2:l -cache:il1 il1:128:32:2:l -cache:dl2 ul2:8192:32:1:l -tlb:itlb itlb:16:4096:4:l -tlb:dtlb dtlb:16:4096:8:l -redir:sim 2levDef.txt ./tests-pisa/bin.little/test.ss
```
### parameters

-predictor type         {`nottaken|taken|perfect|bimod|2lev|comb`}  
-in case of `static prediction` it doesn't matter which parameter of the above is used  
-bpred:bimod     `2048` # bimodal predictor (`2-bit predictor`) config (`<table size>`)  
-bpred:2lev      `1 1024 8 0` # 2-level predictor (`correlating predictor`) config (`<no of registers> <table size> <hist_size> <xor>`)  

## Sample Output 

### 1. static prediction (`backward taken and forward not taken`) stats 

![image](https://github.com/user-attachments/assets/1a32d79a-6aef-4113-8f8d-95c5fd2c8543)

### 2. Bimod prediction (`2-bit prediction`) using 2048 table entry size (default size)  
using `2-bit-prediction` => decreased mispredictions, increased hit predictions, increased accuracy, increased performance than the previous sample output. 

![image](https://github.com/user-attachments/assets/a69c8e98-0612-4cac-9932-5f448933a989)


### 3. Bimod (`2-bit prediction`) Prediction using 16384 table entry size
increasing table entry size => decreased mispredictions, increased hit predictions, increased accuracy, increased performance than the previous sample output. 

![image](https://github.com/user-attachments/assets/43f5b8c9-9825-480a-8580-5a355a5103ec)


### 4. 2lev (`correlating`) prediction using default value 1 register , 1024 entry table , 8 bits , 0 (`xor`)
using `correlating prediction` => decreased mispredictions, increased hit predictions, increased accuracy, increased performance than the previous sample output. 

![image](https://github.com/user-attachments/assets/233e2a67-70ea-4c54-8a39-0e45b1c8de93)



### 5. 2lev (`correlating`) prediction using 1 register , 1024 entry table , 10 bits , 1 (`xor`)
increasing number of bit => decreased mispredictions, increased hit predictions, increased accuracy, increased performance than the previous sample output. 

![image](https://github.com/user-attachments/assets/bc966494-ab5e-4ea7-a28e-80605c125480)


### 6. 2lev (`correlating`) prediction using default value 1 register , 4096 entry table , 11 bits , 1 (`xor`)
the best perfomance and accuracy with inceased table entry size and increased bits.   

![image](https://github.com/user-attachments/assets/235c19ed-44c2-43dd-ae81-4cd270173331)
