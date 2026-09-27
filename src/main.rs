use std::{env, fs, path::PathBuf};

use jsonc_parser::JsonObject;
use layer_shika::{calloop::TimeoutAction, prelude::*, slint::ComponentHandle, slint_interpreter::Value};
use std::time::Duration;
use chrono::{Local, Timelike};

pub mod api;

fn duration_until_next_second() -> Duration {
    let nanos = Local::now().nanosecond();

    Duration::from_nanos(1_000_000_000 - nanos as u64)
}

fn get_panel_values<'a>(value: &'a JsonObject<'a>) -> (&'a str, u8, u32, u32, i32, Layer, &'a str) {
    let component = match value.get("component") {
        Some(jsonc_parser::JsonValue::String(component)) => component, _ => "null",
    };

    let layer = match value.get("layer") {
        Some(jsonc_parser::JsonValue::String(layer)) => layer, _ => "Background",
    };
    let layer = match layer.to_lowercase().as_str() {
        "bottom" => Layer::Bottom,
        "top" => Layer::Top,
        "overlay" => Layer::Overlay,
        _ => Layer::Background
    };

    let namespace = match value.get("namespace") {
        Some(jsonc_parser::JsonValue::String(component)) => component, _ => "null",
    };

    let mut anchors = 0b0000;
    if let Some(jsonc_parser::JsonValue::Array(values)) = value.get("anchors") {
        if let (
            Some(jsonc_parser::JsonValue::Number(r)),
            Some(jsonc_parser::JsonValue::Number(t)),
            Some(jsonc_parser::JsonValue::Number(l)),
            Some(jsonc_parser::JsonValue::Number(b))
        ) = (values.get(0), values.get(1), values.get(2), values.get(3))
        {
            anchors =   r.parse::<u8>().unwrap() * 0b1000 | 
                        t.parse::<u8>().unwrap() * 0b0001 | 
                        l.parse::<u8>().unwrap() * 0b0100 | 
                        b.parse::<u8>().unwrap() * 0b0010;
        }
    }

    let mut width: u32 = 0;
    let mut height: u32 = 0;
    if let Some(jsonc_parser::JsonValue::Array(values)) = value.get("size") {
        if let (
            Some(jsonc_parser::JsonValue::Number(w)),
            Some(jsonc_parser::JsonValue::Number(h))
        ) = (values.get(0), values.get(1))
        {
            width = w.parse().unwrap();
            height = h.parse().unwrap();
        }
    }

    let exclusive: i32 = match value.get("exclusive") {
        Some(jsonc_parser::JsonValue::Number(component)) => component.parse().unwrap(), _ => 0,
    };

    return (component, anchors as u8, width, height, exclusive, layer, namespace);
}

fn add_surface(builder: SurfaceConfigBuilder, value: &jsonc_parser::JsonValue) -> SurfaceConfigBuilder {
    let jsonc_parser::JsonValue::Object(value) = value else { return builder; };

    let (component, anchors, width, height, exclusive, layer, namespace) =
        get_panel_values(value);

    return builder
        .surface(component)
        .width(width)
        .height(height)
        .anchor(AnchorEdges::new(anchors))
        .exclusive_zone(exclusive)
        .layer(layer)
        .namespace(namespace);
}

fn main() -> Result<()> {
    let args: Vec<String> = env::args().collect();

    let mut conf_path = "config.jsonc";
    if args.len() > 1 {
        conf_path = &args[1];
    }
    
    let conf = fs::read_to_string(PathBuf::from(env!("PWD")).join(conf_path)).unwrap_or_default();
    let data = jsonc_parser::parse_to_value(&conf, &Default::default())
        .expect(format!("Failed to parse {}", conf_path).as_str())
        .expect(format!("{} contained no value or does not exist", conf_path).as_str());
    
    // This looks gross
    if let jsonc_parser::JsonValue::Object(object) = data {
        let ui_path: &str = match object.get("shell") {
            Some(jsonc_parser::JsonValue::String(ui_path)) => ui_path, _ => "ui/shell.slint",
        };
        let ui_path = PathBuf::from(env!("PWD")).join(ui_path);

        if let Some(jsonc_parser::JsonValue::Object(panels)) = object.get("panels") {
            let mut surfaces = panels.clone().into_iter();
            let (_, first) = surfaces
                .next()
                .expect("no surfaces configured");
            let jsonc_parser::JsonValue::Object(first) = first else { panic!("first surface must be an object"); };

            let (component, anchors, width, height, exclusive, layer, namespace) =
                get_panel_values(&first);

            let mut shell = Shell::from_file(ui_path)
                .surface(component)
                .width(width)
                .height(height)
                .anchor(AnchorEdges::new(anchors))
                .exclusive_zone(exclusive)
                .layer(layer)
                .namespace(namespace);

            for (_, value) in surfaces {
                shell = add_surface(shell, &value);
            }

            // Setup timers, rust callbacks, etc
            let mut shell = shell.build()?;
            let event_loop = shell.event_loop_handle();
            shell.with_all_surfaces(|_name, instance| {
                api::setup_fns(instance);

                let weak = instance.as_weak();

                event_loop
                    .add_timer(
                        Duration::ZERO,
                        move |_deadline, _state| {
                            if let Some(instance) = weak.upgrade() {
                                instance
                                    .set_global_property("ShellAPI", "tick", Value::from(Local::now().second()))
                                    .expect("failed to set tick");
                            }

                            TimeoutAction::ToDuration(duration_until_next_second())
                        },
                    )
                    .expect("failed to add clock timer");
            });

            shell.run()?;
        }
    }

    return Ok(());
}
