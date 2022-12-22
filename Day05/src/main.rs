mod app;
mod crates_widget;
mod parse;

use crate::app::App;
use crate::parse::parse_input;
use anyhow::Result;
use crossterm::event::{DisableMouseCapture, EnableMouseCapture};
use crossterm::execute;
use crossterm::terminal::{
    disable_raw_mode, enable_raw_mode, EnterAlternateScreen, LeaveAlternateScreen,
};
use std::{env, io};
use tui::{backend::CrosstermBackend, Terminal};

fn main() -> Result<()> {
    if env::args().count() != 2 {
        println!("Usage: day5 <file>");
        return Ok(());
    }

    let filename = env::args().nth(1).unwrap();

    let input = parse_input(&std::fs::read_to_string(filename)?)?;
    let crates = input.crates;
    let moves = input.moves;

    enable_raw_mode()?;
    let mut stdout = io::stdout();

    execute!(stdout, EnterAlternateScreen, EnableMouseCapture)?;
    let backend = CrosstermBackend::new(stdout);
    let mut terminal = Terminal::new(backend)?;

    App::new(crates, moves, &mut terminal).run()?;

    // restore terminal
    disable_raw_mode()?;
    execute!(
        terminal.backend_mut(),
        LeaveAlternateScreen,
        DisableMouseCapture
    )?;
    terminal.show_cursor()?;
    Ok(())
}
