pub struct Tile {
    value: u8,

    covered: bool,
}

pub struct Board {
    width: usize,
    height: usize,

    tiles: Vec<Tile>,
}

impl Board {
    pub fn new(width: usize, height: usize) -> Self {
        Self {
            width: width,
            height: height,
            tiles: Vec::with_capacity(width * height),
        }
    }

    pub fn draw(&self) {
        for y in 0..self.height {
            for x in 0..self.width {
                let tile = self.get(x, y);

                if (tile.covered) {
                    print!("## ")
                }
                else {
                    print!("__ ")
                }
            }
        }
    }

    pub fn get(&self, x: usize, y: usize) -> &Tile {
        &self.tiles.get(y * self.width + x).expect("index out of range")
    }

    pub fn get_mut(&mut self, x: usize, y: usize) -> &mut Tile {
        self.tiles.get_mut(y * self.width + x).expect("index out of range")
    }
}

