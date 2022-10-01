# When run in CLI mode, the frontend/ is unused

use std::cli::Flag

main: (cli_mode: Flag) -> Status {
    if cli_mode {
        // launch interactive prompt
        interactive_prompt()
    }
    else {
        gui()
    }
}
