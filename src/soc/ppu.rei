#*
    Parallel Processing Unit
*#

// I mean, you dont even need a command processor then?
// the shader does its job the moment you send it in?

// Hardware description (descriptive?)

// new should be auto derived, if you dont want it, do @derive(new = false, ...)

use std::spectro

/*
Bits[4], etc
Bits[N]: [bool; N]
Bool => on or off signal
etc.
*/

// to return mutliple lines, use a tuple (a, b) or a, b?
// but a + b also makes sense? no

// Dispatch: (a: Bits[4], b: Bits[1]) -> Bits[1] {
//     a + b
// }

// I think everything should be packed by default
// also prob better just to list out every single instruction and their corresponding value?
// or spectro will handle it?

// NOTE: the clock and reset are auto handled for you like chisel. But unlike chisel you cant change them at all
// this allows better synchronicity and less hassle given that you have a valid and good design

# RISCY ISA
PPUInstruction: enum {
    // integer
    ArithmeticSigned32
    ArithmeticUnsigned32
    // float
    FloatSigned32
    FloatUnsigned32
    // special ops
    SpecialInstructions
}

Shader: Vec[PPUInstruction]

ShaderThread: {
    shader: Shader
}

Wavefront: [ShaderThread; 32]

// state is weird in the hardware world
// at reset, you dont expect any state

// is it possible to have fn pointer as the type in an arr? probably?

// ditching is automatic. But its good practice to simply write |expr| I think? ...or not

// wait so allow inputs and outputs to be connected elsewhere
// every clock tick, Main() will be called with the input, if there is any
// if no input, no call (? I think. Otherwise we can generate a dummy overload Main() that does nothing)
Main: (input: Block4K) {
    // basically main memory access/push and memory write
    let signal, wavefront = Dispatch(input)
    // send signal to correct cluster. There are C clusters
    const clusters = [ShaderCluster; C]
    clusters[signal](wavefront)
}

# spectro allows implicit mapping?

# N bits for N warps. Possible to deploy the same wavefront simultaneously on another thread?
DispatchSignal[N]: Bits[N]

// all "local" variables are actually mapped to permanent modules? or maybe just const? or maybe static?

Dispatch: (wavefront: Wavefront) -> (DispatchSignal, Wavefront) {
    // choose a random queue from your queues
    // or have your queue wire to the dispatcher? Uhh..
    // you would have this connected automatically by the PPU
    // just a bunch of numbers. K = N basically?
    const queues = [u32; K]

    (queues.random(), wavefront)
}

// should state be const defined? I mean probably...
// but the thing is you can mut it?
// like const mut? uhh
// basically no need to recreate it every time you enter. But I mean how does the changes work and propagate?
// maybe JS/TS does it in a pretty weird way

# catch a signal from the dispatcher and push the wavefront to your local queue
Queue: (wavefront: Wavefront) -> Wavefront {
    // basically a circular queue of registers. Should spectro impl this?
    // Q amount of elements before overflow?
    // only const elem if owned. Otherwise let. Static is a bit weird I think
    const queue = CircBuffer[spectro::Reg32, Q]

    // push the wavefront
    queue.push(wavefront)

    // return the first one
    queue.pop()
}

// get wavefront from dispatcher and queue
ShaderCluster: (wavefront: Wavefront) {
    // queues and shader processors
    let next = Queue(wavefront)

    // 
}

ShaderProcessor: () {}

// DecodedInstruction: PPUInstruction

// the problem with "Decode" is that it is already kind of decoded in the code

# local per-shader cluster decoder -> ALU input?
// Decode: (wavefront: Wavefront) {}

// wait no so you basically connect everything all at once in a shader cluster fn and a ppu module fn

// so how does this even work next?
