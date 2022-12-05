use crate::crates_widget::{AnimationPath, CratesWidget};
use crate::parse::Move;
use anyhow::Result;
use crossterm::event;
use crossterm::event::{poll, Event};
use std::time::Duration;
use tui::backend::Backend;
use tui::layout::Rect;
use tui::widgets::{Block, Borders};
use tui::Terminal;

#[derive(Eq, PartialEq)]
enum Part {
    One,
    Two,
    Unset,
}

pub struct App<'a, B: Backend> {
    crates: Vec<Vec<char>>,
    moves: Vec<Move>,
    animate: bool,
    terminal: &'a mut Terminal<B>,
    current_move: usize,
    animation_path: Option<AnimationPath>,
    swapped: Option<Vec<char>>,
    part: Part,
}

impl<'a, B: Backend> App<'a, B> {
    pub fn new(crates: Vec<Vec<char>>, moves: Vec<Move>, terminal: &'a mut Terminal<B>) -> Self {
        Self {
            crates,
            moves,
            animate: true,
            terminal,
            current_move: 0,
            animation_path: None,
            swapped: None,
            part: Part::Unset,
        }
    }

    fn get_max_height_in_range(&self, from: u16, to: u16) -> u16 {
        let range = if from < to { from..=to } else { to..=from };
        let mut max_height = 0;
        for i in range {
            let height = self.crates[i as usize].len() as u16;
            if height > max_height {
                max_height = height;
            }
        }
        max_height
    }

    fn step(&mut self) {
        if self.current_move == self.moves.len() || self.part == Part::Unset {
            return;
        }

        // Start a new swap
        if self.animation_path.is_none() {
            let swap = self.moves[self.current_move];
            let max_height = self.get_max_height_in_range(swap.from, swap.to);
            let from_stack_height = self.crates[swap.from as usize].len() as u16;
            let to_stack_height = self.crates[swap.to as usize].len() as u16;

            self.swapped = match self.part {
                Part::One => Some(vec![self.crates[swap.from as usize].pop().unwrap()]),
                Part::Two => {
                    let mut swapped = Vec::new();
                    // This is not a good way to do this
                    for _ in 0..swap.count {
                        swapped.push(self.crates[swap.from as usize].pop().unwrap());
                    }
                    swapped.reverse();
                    Some(swapped)
                }
                _ => None,
            };

            if self.animate {
                self.animation_path = Some(AnimationPath::new(
                    (swap.from, from_stack_height),
                    (swap.to, to_stack_height),
                    max_height,
                ));
            }
        }

        if !self.animate || !self.animation_path.as_mut().unwrap().next() {
            let swap = self.moves[self.current_move];
            self.animation_path = None;
            match self.part {
                Part::One => {
                    self.moves[self.current_move].count -= 1;

                    if self.moves[self.current_move].count == 0 {
                        self.current_move += 1;
                    }
                }
                Part::Two => {
                    self.current_move += 1;
                }
                _ => {}
            }

            self.crates[swap.to as usize].append(&mut self.swapped.as_ref().unwrap().clone());
        }
    }

    fn draw(&mut self) -> Result<()> {
        self.terminal.draw(|f| {
            let size = f.size();
            let frame = Block::default().title("Crates").borders(Borders::ALL);
            let mut display = CratesWidget::new(&self.crates);

            if let Some(path) = &self.animation_path {
                display = display.with_swap(self.swapped.as_ref().unwrap(), path);
            }

            f.render_widget(frame, size);
            f.render_widget(display, Rect::new(1, 1, size.width - 2, size.height - 3));
        })?;
        Ok(())
    }

    pub fn run(&mut self) -> Result<()> {
        loop {
            self.step();
            self.draw()?;
            if poll(Duration::from_millis(0))? {
                if let Event::Key(key) = event::read().unwrap() {
                    match key.code {
                        event::KeyCode::Char('q') => break,
                        event::KeyCode::Char('a') => self.animate = !self.animate,
                        _ => {}
                    }

                    if self.part == Part::Unset {
                        match key.code {
                            event::KeyCode::Char('1') => self.part = Part::One,
                            event::KeyCode::Char('2') => self.part = Part::Two,
                            _ => {}
                        }
                    }
                }
            }
        }
        Ok(())
    }
}
