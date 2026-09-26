use chrono::Local;
use layer_shika::{slint::SharedString, slint_interpreter::Value};

pub fn setup_fns(instance: &layer_shika::slint_interpreter::ComponentInstance) {
    instance.set_global_callback("ShellAPI", "add_numbers", |args| {
        let a: i32 = args[0].clone().try_into().unwrap();
        let b: i32 = args[1].clone().try_into().unwrap();

        return Value::from(a + b);
    }).expect("bad");
    instance.set_global_callback("ShellAPI", "get_time", |args| {
        let now = Local::now();
        let vertical: bool = args[0].clone().try_into().unwrap();
        let time = if !vertical 
            { now.format("   %_I:%M:%S %p") } 
        else { now.format("%_I:%M %p") };

        let time2 = if !vertical 
            { now.format("%a, %b %d %Y") } 
        else { now.format(" %d/%m/%Y ") };

        let text = SharedString::from(format!("{}\n{}",
            time,
            time2
        ));

        return Value::from(text);
    }).expect("bad");
}