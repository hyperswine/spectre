#*
    Spectre ISA
*#

// the tihng with hardware descriptions is that you should deal directly with hardware
// and declaratively...

FullAdder: (bit1: Bit, bit2: Bit, carry: Bit) -> (Sum, Carry) {
    let p1 = bit1 ^ bit2
    let sum = p1 ^ carry
    let p3 = carry & p1
    let p4 = bit1 & bit2
    let carry_out = p3 | p4 

    sum, carry_out
}

Sum: Bits
Carry: Bits

RippleAdder[N]: (data1: Bits[N], data2: Bits[N], carry_in: Carry) -> (Sum[N], Carry) {
    map(data1, data2).map(d1, d2, index => {
        FullAdder(data1[index], data2[index], carry_in)
    })

    // maybe uhh connect them all?
    // somehow use dependent data types?
    let adder = (x, y, carry) => FullAdder(x, y, carry)
    let adders = [adder; N]

    // "sequential in a way"... wait cant they basically be like 2 cycles? or just one?
    // so the clock doesnt step in this case?
    mut carry = carry_in
    mut sum = Sum[N]()

    for i in 0..N {
        let _sum, _carry = FullAdder(data1[index], data2[index], carry)
        carry = _carry
        // on an empty array or array with default values, append
        // replaces the data and increments size
        sum.append(_sum) 
    }

    sum, carry
}

Instruction: {
    fn_id: Id
}

Data: u64
Address: u64
DataFetch: Address -> Data

// all base instructions operate on 64 bits of data
Instruction: enum {
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


// executor can send data back to fn buffer as Result for IO (effects)
Executor: (function: Fn) -> Fn? {
    let lhs = function.sp()
    let instruction = function.next_instruction()

    // would fetch from cache and go into the adder. If not in cache, stall until data arrives
    // only DRAM is a "part" of the cpu complex... other devices are treated as IO
    let fetch = (addr) => Cache(addr)

    match instruction {
        Add(rhs) => lhs + fetch(rhs)
    }
}

// the thing is:
// its only an addr to the actual data in cache right?
// cache data is like tagged with fn id though?
// uhh

// an executor uhh, takes in a function's ID and stackframe address?
// so ID, SP...?
// then it just works

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
