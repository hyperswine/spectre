# When run in CLI mode, the frontend/ is unused

use std::cli::Flag

main: (cli_mode: Flag) -> Status {
    // launch interactive prompt
    if cli_mode => interactive_prompt()
    else => gui()

    Ok()
}
