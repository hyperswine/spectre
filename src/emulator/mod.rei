#*
    Emulation Logic for Spectro SiP
*#

// NOTE: data Status = |(), ()|
// Idea is to subclass status and use it in your own use cases... It shouldnt be hard...
// I just dunno if it is even a good idea to have 'data' and stuff. Arghh
// I think everything should just be a c struct from scratch {} which you can assign to an Ident

Status = type String!

export fn start_aarch64() -> Status {
    // microarch independent bios

}
