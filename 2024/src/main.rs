#![allow(unused)]

use std::collections::{BTreeMap, HashMap};
use std::fmt::Pointer;
use std::io::IsTerminal;
use std::time::Duration;
use std::{error::Error, fmt::Debug, fs, path::Path, time::Instant};

use clap::Parser;
use clap_derive::{Parser, ValueEnum};

use indicatif::style::ProgressTracker;
use indicatif::FormattedDuration;
use indicatif::ProgressStyle;
use scopeguard::defer;
use tracing::trace;
use tracing::Span;
use tracing::{event, info};
use tracing::{info_span, Level};
use tracing::{instrument, Instrument};
use tracing_indicatif::span_ext::IndicatifSpanExt;
use tracing_indicatif::IndicatifLayer;
use tracing_subscriber::fmt::format::{DefaultFields, FmtSpan};
use tracing_subscriber::fmt::{format, FormatFields};
use tracing_subscriber::layer::SubscriberExt;
use tracing_subscriber::registry::LookupSpan;
use tracing_subscriber::util::SubscriberInitExt;

mod day_1;
mod day_10;
mod day_11;
mod day_12;
mod day_2;
mod day_3;
mod day_4;
mod day_5;
mod day_6;
mod day_7;
mod day_8;
mod day_9;

mod grid;

#[derive(Debug, Clone, ValueEnum, PartialEq, Eq, Hash)]
enum Input {
    Example,
    Input,
    Both,
}

impl IntoIterator for &Input {
    type Item = (&'static str, Input);
    type IntoIter = std::vec::IntoIter<Self::Item>;

    fn into_iter(self) -> Self::IntoIter {
        match self {
            Input::Example => vec![("example.txt", Input::Example)].into_iter(),
            Input::Input => vec![("input.txt", Input::Input)].into_iter(),
            Input::Both => {
                vec![("example.txt", Input::Example), ("input.txt", Input::Input)].into_iter()
            }
        }
    }
}

#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
struct Args {
    /// Run all days
    #[arg(short, long, conflicts_with = "day", action = clap::ArgAction::SetTrue, required_unless_present = "day")]
    all: bool,

    /// Day to run
    #[arg(short, long, conflicts_with = "all", required_unless_present = "all", value_parser = clap::value_parser!(u8).range(1..=25))]
    day: Option<u8>,

    /// Part to run
    #[arg(short, long, default_value = "both")]
    input: Input,
}

trait Solution {
    fn part_1(&self) -> Result<i64, Box<dyn Error>>;
    fn part_2(&self) -> Result<i64, Box<dyn Error>>;
}

struct DayOutput {
    day: u8,
    by_input: HashMap<Input, (Duration, DayPartOutput, DayPartOutput)>,
}

struct DayPartOutput {
    result: i64,
    duration: Duration,
}

struct Output {
    days: Vec<DayOutput>,
}

impl Args {
    fn solution_for_day(
        &self,
        day: u8,
        input: String,
    ) -> Result<Box<dyn Solution>, Box<dyn std::error::Error>> {
        match day {
            1 => Ok(Box::new(day_1::Day1::new(input)?)),
            2 => Ok(Box::new(day_2::Solution::new(input)?)),
            3 => Ok(Box::new(day_3::Solution::new(input)?)),
            4 => Ok(Box::new(day_4::Solution::new(input)?)),
            5 => Ok(Box::new(day_5::Solution::new(input)?)),
            6 => Ok(Box::new(day_6::Solution::new(input)?)),
            7 => Ok(Box::new(day_7::Solution::new(input)?)),
            8 => Ok(Box::new(day_8::Solution::new(input)?)),
            9 => Ok(Box::new(day_9::Solution::new(input)?)),
            10 => Ok(Box::new(day_10::Solution::new(input)?)),
            11 => Ok(Box::new(day_11::Solution::new(input)?)),
            12 => Ok(Box::new(day_12::Solution::new(input)?)),
            _ => return Err(format!("Day {} not implemented", day).into()),
        }
    }

    fn run_day(&self, day: u8) -> Result<DayOutput, Box<dyn Error>> {
        let day_span = info_span!("Day", day = day);
        let day_output = DayOutput {
            day,
            by_input: HashMap::new(),
        };
        let _guard = day_span.enter();

        let dir = Path::new(env!("CARGO_MANIFEST_DIR"))
            .join("src")
            .join(format!("day_{}", day));

        let mut output = DayOutput {
            day,
            by_input: HashMap::new(),
        };

        for (file_name, input) in &self.input {
            let input = fs::read_to_string(dir.join(file_name))?;

            let solution = {
                let start = Instant::now();
                defer! {
                    let name = format!("day_{}/{}", day, file_name);
                    info!("Solution for {:?} in {:?}", name, start.elapsed());
                }
                let sol_span = info_span!(parent: &day_span, "Parsing day", file_name = file_name);
                let enter: tracing::span::Entered<'_> = sol_span.enter();

                self.solution_for_day(day, input)
            }?;
            {
                let start = Instant::now();
                let part_1_span = info_span!(parent: &day_span, "Part 1", file_name = file_name, result = tracing::field::Empty);
                let _guard = part_1_span.enter();
                let result = solution.part_1()?;
                part_1_span.record("result", tracing::field::debug(result));
                info!("Part 1: {:#?} in {:?}", &result, start.elapsed());
            }
            {
                let start = Instant::now();
                let part_2_span = info_span!(parent: &day_span, "Part 2", file_name = file_name, result = tracing::field::Empty);
                let _guard = part_2_span.enter();
                let result = solution.part_2()?;
                part_2_span.record("result", tracing::field::debug(result));
                info!("Part 2: {:#?} in {:?}", &result, start.elapsed());
            }
        }

        Ok(day_output)
    }
    fn run(&self) -> Result<(), Box<dyn Error>> {
        let run_span = tracing::debug_span!("Run");
        let _guard = run_span.enter();
        if self.all {
            for day in 1..=25 {
                self.run_day(day).inspect_err(|e| {
                    tracing::error!("Error running day {day}: {error}", day = day, error = e);
                })?;
            }
        } else if let Some(day) = self.day {
            self.run_day(day).inspect_err(|e| {
                tracing::error!("Error running day {day}: {error}", day = day, error = e);
            })?;
        } else {
            return Err("No day specified".into());
        }
        Ok(())
    }
}

fn main() -> Result<(), Box<dyn Error>> {
    let indicatif_layer = IndicatifLayer::new().with_progress_style(
        ProgressStyle::with_template("{span_child_prefix}{spinner:.green} {span_name}{{{span_fields}}} {msg} in {elapsed_exact}")
            .unwrap()
            .with_key(
                "elapsed_exact",
                |progress_state: &indicatif::ProgressState, write: &mut dyn core::fmt::Write| {
                    write.write_str(format!("{:?}", progress_state.elapsed()).as_str());
                },
            ),
    );
    tracing_subscriber::registry()
        .with(
            tracing_subscriber::fmt::layer()
                .with_ansi(std::io::stderr().is_terminal())
                // .event_format(format::format().pretty().with_source_location(false))
                .without_time()
                // .with_span_events(FmtSpan::CLOSE)
                .with_writer(indicatif_layer.get_stderr_writer()),
        )
        .with(indicatif_layer)
        .init();

    let args = Args::parse();
    args.run()
}
