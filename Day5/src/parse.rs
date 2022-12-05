use anyhow::{Context, Result};
use regex::Regex;

#[derive(Copy, Clone)]
pub struct Move {
    pub count: usize,
    pub from: u16,
    pub to: u16,
}

pub struct Environment {
    pub crates: Vec<Vec<char>>,
    pub moves: Vec<Move>,
}

#[derive(PartialEq)]
enum ParseMode {
    Crates,
    Moves,
}

pub fn parse_input(input: &str) -> Result<Environment> {
    let mut crates = Vec::new();
    let mut moves = Vec::new();

    // Split input at newlines
    let lines = input.split('\n');
    let mut mode = ParseMode::Crates;

    for line in lines {
        if line.starts_with(" 1") || line.is_empty() {
            mode = ParseMode::Moves;
            continue;
        }

        if mode == ParseMode::Crates {
            let mut stack_index = 0;
            let chars: Vec<char> = line.chars().collect();
            loop {
                let crate_index = stack_index * 4 + 1;
                if crate_index + 1 >= chars.len() {
                    break;
                }

                if chars[crate_index] == ' ' {
                    stack_index += 1;
                    continue;
                }

                let crate_char = chars[crate_index];
                if crates.len() <= stack_index {
                    for _ in 0..stack_index - crates.len() + 1 {
                        crates.push(Vec::new());
                    }
                }

                crates[stack_index].push(crate_char);
                stack_index += 1;
            }
        } else {
            let re = Regex::new(r"move (\d+) from (\d+) to (\d+)")?;
            let captures = re
                .captures(line)
                .with_context(|| format!("Failed to parse move {}", line))?;
            let count = captures
                .get(1)
                .context("Couldn't get count for move")?
                .as_str()
                .parse::<usize>()?;
            let from = captures
                .get(2)
                .context("Couldn't get first stack for move")?
                .as_str()
                .parse::<u16>()?
                - 1;
            let to = captures
                .get(3)
                .context("Couldn't get second stack for move")?
                .as_str()
                .parse::<u16>()?
                - 1;
            moves.push(Move { count, from, to });
        }
    }

    // Reverse all the crates so they're in the right order
    for stack in crates.iter_mut() {
        stack.reverse();
    }

    Ok(Environment { crates, moves })
}
