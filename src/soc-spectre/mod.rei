#*
    Spectre ISA
*#

Adder: (data1: u64, data2: u64) {
    // full adder does a bitwise addition
    addr1 + addr2
}

// executor can send data back to fn buffer as Result
Executor: (instruction: Instruction) -> Fn? {
    // decode the instruction and send to the corresponding subcomponents
    match instruction {
        Add(addr1, addr2) => Adder(addr1, addr2)
    }
}

Instruction: {
    fn_id: Id
}

// so just some address
Data: u64

// all base instructions operate on 64 bits of data
Instruction: {
    Add: (Data, Data)
    Sub: (Data, Data)
    Mult: (Data, Data)
    Div: (Data, Data)
    Bitwise: (Data, Data)

    Jump: Offset
    Yield

    // accelerator
    Accelerate: enum {
        // Vadd or Vmap?
        Map
        Hash
        Discretize
    }
}

// the thing is:
// its only an addr to the actual data in cache right?
// cache data is like tagged with fn id though?
// uhh

// an executor uhh, takes in a function's ID and stackframe address?
// so ID, SP...?
// then it just works

Address: u64

DataFetch: Address -> Data

Executor: (function: Fn) {
    let lhs = function.sp()
    let instruction = function.next_instruction()

    // decoder part 1
    // take the addresses that it refers to? or offsets?
    // let ins_type: DataFetch = match instruction {
    //     OffsetInstruction => (offset) => Cache(Offset(offset))
    //     AddressableInstruction => (offset) => Cache(Address(address))
    // }

    let fetch = (addr) => Cache(addr)

    match instruction {
        Add(rhs) => lhs + fetch(rhs)
    }

    // ins_type is a function that tells the executor to contact the cache for the data

    // decoder part 2
    // match instruction {
        // would fetch from cache and go into the adder. If not in cache, stall until data arrives
        // only DRAM is a "part" of the cpu complex... other devices are treated as IO
    //     Add(rhs) => lhs + ins_type(rhs)
    // }
}

/*
how are things compiled?
well first of all use sp for lhs and auto increment by size of lhs
if no lhs, first store a value on sp from somewhere
rhs...
rhs can also come from that somewhere

somwhere sources:
data section
immediates
previously stored values on the stack?

with data section:
static data
vDSO and shared data? or an API for it

so

x = 3*5 + 1
y = 5/9 + x
z = x * x + 3 / 6 % 10

becomes a series of steps
dependent and independent?
can the independent be done first?

store: sp = value and sp -= value.size()

store 3*5 + 1 MAC

since y isnt being used, we can just ditch it?
store 5/9 immediate
compute $sp + $(sp - size of immediate)

now, we can then increment the stack again since we no longer need y

store $sp * $sp
store 3/6
store $sp mod 10
compute $sp + $(sp - sizeof previous two instructions)

SO note that sp stuff is quite volatile
read only and other global stuff could go into another buffer?
so one is burst, low freq traffic
one is small, high freq traffic
*/
