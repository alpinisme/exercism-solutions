use std::fmt;

#[derive(PartialEq, Debug)]
pub struct Clock {
    pub hours: i32,
    pub minutes: i32,
}

impl Clock {
    fn has_overflow(offset: i32, val: i32) -> bool {
        val >= 0 || val % offset == 0
    }

    pub fn new(hours: i32, minutes: i32) -> Self {
        let total_hours = if Clock::has_overflow(60, minutes) {
            hours + minutes / 60
        } else {
            hours + minutes / 60 - 1
        };

        Clock {
            hours: if Clock::has_overflow(24, total_hours) {
                total_hours % 24
            } else {
                total_hours % 24 + 24
            },
            minutes: if Clock::has_overflow(60, minutes) {
                minutes % 60
            } else {
                minutes % 60 + 60
            },
        }
    }

    pub fn add_minutes(&self, minutes: i32) -> Self {
        Clock::new(self.hours, self.minutes + minutes)
    }
}

impl fmt::Display for Clock {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{:0>2}:{:0>2}", self.hours, self.minutes)
    }
}
