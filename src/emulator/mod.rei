#*
    Emulation Logic for Spectro SiP
*#

// NOTE: data Status = |(), ()|
// Idea is to subclass status and use it in your own use cases... It shouldnt be hard...
// I just dunno if it is even a good idea to have 'data' and stuff. Arghh
// I think everything should just be a c struct from scratch {} which you can assign to an Ident

// Just a bare metal emulator

Status: String!

// Rust is a keyword for any rust deps you're using. Maybe annotation instead?
use Rust::riscv
use Rust::aarch64

@derive(Default)
Functionality: ()

impl Functionality {
    // the new snippet can generate this
    fn new() -> Self {
        ()
    }

    fn execute_program(hardware_program: HardwareProgram) {
        // interpret the program in your own ISA/ucode
    }
}

// implicit promotion to a tagged union if not already
PCIeDevice: {
    functionality: Functionality
}

// PCIeDevice becomes an implicit tagged union with a default PCIeDevice variant and a PCIeSwitch variant
// maybe the variant keyword?
PCIeSwitch: PCIeDevice variant {
    connections: Vec<PCIeDevice>
}

// to use inheritance... uhh you cant. You can use trait objects though. You have to build your own dynamic dispatcher and use the dyn keyword
// even though a static array Arr[T; Size] is good, you actually want to use Vec<> at first because its just so much easier 

HardwareSpec: {
    pcie: {
        connections: Vec<PCIeDevice>
    }
}

export fn start_aarch64(hardware_spec: HardwareSpec) -> Status {
    // microarch independent bios

    // maybe get the core topology and etc and hardware topology

    // startup

    // execute a program, and hand off execution to it
}

fn evaluate<T>(instruction: Instruction) -> T {
    // shorthand for config arch aarch64
    @cfg(aarch64)
    return aarch64::evaluate(instruction)
    @cfg(riscv)
    return riscv::evaluate(instruction)
}

// Execution loop
fn execute(program: Program) {
    while let Ok(instruction) = program.next() {
        match instruction {
            evaluate(instruction)
        }
    }
}
