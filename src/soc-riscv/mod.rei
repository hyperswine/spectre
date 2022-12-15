#*
    SoC Description
*#

use rocket_core::prelude::*

// NOTE: extend {} doesnt mean extend the base object, thats just {} itself. Extend {} actually means extend Self {}

Core: extend RocketCore {
    // All ALU instructions already implemented. Caches kinda

    connect: (&mut self, ddr_line: DDRLine) {
        // connect self to it, the first part of the pipeline
        self.pipeline.connect(ddr_line)
    }

    pipeline: (&mut self) {}

    // connect core to a NUMA domain RAM

    // connect core to another core
}

// uarch
// interrupts and such!
// wait...

Core[NAlu, NDecode]: (memory_line: MemoryLine, instructions: [Instruction; NDecode], alu: [RocketAlu; NAlu]) {
    // decode the instructions to the ALU inputs
    let decoded_instructions = [Decoder(); NDecode]

    alu.for_each((a, index) => a.connect(decoded_instructions[index]))

    // one rocket alu per core...?
    // or two

    // cache
    // L1 config gives you both instruction and data
    let cache = Cache(L1, 1KB)
    let tlb = TLB(L1, 1KB)

    cache.connect(tlb)

    tlb.connect(memory)

    cache.connect(alu)
}

CachePreset: enum {
    L1
    L2
    L3
}

CacheWritePolicy: enum {
    WriteBack
    WritheThrough
}

CachePolicy: enum {
    LeastRecentlyUsed
    // counter from 0-n_entries - 1 and reset
    Counter
}

Cache: () {}
