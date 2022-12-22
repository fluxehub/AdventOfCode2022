use tui::buffer::Buffer;
use tui::layout::Rect;
use tui::style::Style;
use tui::widgets::Widget;

pub struct AnimationPath {
    path: Vec<(u16, u16)>,
    step: usize,
}

impl AnimationPath {
    // Path is up to max_height from point "from", across to point "to" and then down
    pub fn new(from: (u16, u16), to: (u16, u16), max_height: u16) -> Self {
        let mut path = Vec::new();
        let (mut x1, mut y1) = from;
        let (mut x2, mut y2) = to;
        x1 *= 4;
        x2 *= 4;
        y1 += 1;
        y2 += 1;
        for y in (y1 - 1)..=max_height {
            path.push((x1, y));
        }
        if x1 < x2 {
            for x in x1..=x2 {
                path.push((x, max_height));
            }
        } else {
            for x in (x2..=x1).rev() {
                path.push((x, max_height));
            }
        }
        for y in (y2..=max_height).rev() {
            path.push((x2, y));
        }
        Self { path, step: 0 }
    }

    pub fn current(&self) -> (u16, u16) {
        self.path[self.step]
    }

    pub fn next(&mut self) -> bool {
        self.step += 1;
        self.step < self.path.len()
    }
}

pub struct CratesWidget<'a> {
    crates: &'a Vec<Vec<char>>,
    swapped: Option<&'a [char]>,
    path: Option<&'a AnimationPath>,
}

impl<'a> CratesWidget<'a> {
    pub fn new(crates: &'a Vec<Vec<char>>) -> Self {
        Self {
            crates,
            swapped: None,
            path: None,
        }
    }

    pub fn with_swap(mut self, swapped: &'a [char], path: &'a AnimationPath) -> Self {
        self.swapped = Some(swapped);
        self.path = Some(path);
        self
    }

    fn get_max_height(&self) -> usize {
        let height = self.crates.iter().map(|c| c.len()).max().unwrap_or(0);
        height
    }

    fn get_row_string(&self, row: usize) -> String {
        let mut string = String::new();
        for stack in self.crates.iter() {
            if stack.len() > row {
                string.push_str(format!("[{}] ", stack[row]).as_str());
            } else {
                string.push_str("    ");
            }
        }
        string
    }
}

impl<'a> Widget for CratesWidget<'a> {
    fn render(self, area: Rect, buf: &mut Buffer) {
        let width = (self.crates.len() * 4 - 1) as u16;
        let x = area.width / 2 - width / 2;
        let y = area.bottom();
        let mut row_string = String::new();
        for i in 0..self.crates.len() {
            row_string.push_str(format!(" {}  ", i + 1).as_str());
        }
        buf.set_string(x, y, row_string, Style::default());

        for i in 0..self.get_max_height() {
            let y = y - i as u16 - 1;
            if y < area.top() {
                break;
            }
            let row_string = self.get_row_string(i);
            buf.set_string(x, y, row_string, Style::default());
        }

        if let Some(swapped) = self.swapped {
            let (dx, dy) = self.path.unwrap().current();
            for i in 0..swapped.len() {
                let y = y as i32 - dy as i32 - i as i32 - 1;
                if y < area.top() as i32 {
                    break;
                }
                let y = y as u16;
                let row_string = format!("[{}] ", swapped[i]);
                buf.set_string(x + dx, y, row_string, Style::default());
            }
        }
    }
}
