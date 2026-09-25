use std::{fs, path::PathBuf};

use jsonc_parser::JsonObject;
use layer_shika::prelude::*;

pub mod api;

fn get_panel_values<'a>(value: &'a JsonObject<'a>) -> (&'a str, u8, u32, u32, i32, &'a str) {
    let component = match value.get("component") {
        Some(jsonc_parser::JsonValue::String(component)) => component, _ => "null",
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

    let exclusive: i32 = match value.get("anchors") {
        Some(jsonc_parser::JsonValue::Number(component)) => component.parse().unwrap(), _ => 0,
    };

    return (component, anchors as u8, width, height, exclusive, namespace);
}

fn add_surface(builder: SurfaceConfigBuilder, value: &jsonc_parser::JsonValue) -> SurfaceConfigBuilder {
    let jsonc_parser::JsonValue::Object(value) = value else { return builder; };

    let (component, anchors, width, height, exclusive, namespace) =
        get_panel_values(value);

    return builder
        .surface(component)
        .width(width)
        .height(height)
        .anchor(AnchorEdges::new(anchors))
        .exclusive_zone(exclusive)
        .namespace(namespace);
}

fn main() -> Result<()> {
    let conf = fs::read_to_string("ui/layer.jsonc").unwrap_or_default();
    let data = jsonc_parser::parse_to_value(&conf, &Default::default())
        .expect("failed to parse JSONC")
        .expect("JSONC contained no value");
    let ui_path = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("ui/shell.slint");

    if let jsonc_parser::JsonValue::Object(object) = data {
        let mut surfaces = object.into_iter();
        let (_, first) = surfaces
            .next()
            .expect("no surfaces configured");
        let jsonc_parser::JsonValue::Object(first) = first else { panic!("first surface must be an object"); };

        let (component, anchors, width, height, exclusive, namespace) =
            get_panel_values(&first);

        let mut shell = Shell::from_file(ui_path)
            .surface(component)
            .width(width)
            .height(height)
            .anchor(AnchorEdges::new(anchors))
            .exclusive_zone(exclusive)
            .namespace(namespace);

        for (_, value) in surfaces {
            shell = add_surface(shell, &value);
        }

        let mut shell = shell.build()?;
        shell.with_all_surfaces(|_name, instance| {
            api::setup_fns(instance);
        });

        shell.run()?;
    }

    return Ok(());
}
