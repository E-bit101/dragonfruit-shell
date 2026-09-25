use layer_shika::slint_interpreter::Value;

pub fn setup_fns(instance: &layer_shika::slint_interpreter::ComponentInstance) {
    instance.set_global_callback("ShellAPI", "add_numbers", |args| {
        let a: i32 = args[0].clone().try_into().unwrap();
        let b: i32 = args[1].clone().try_into().unwrap();

        return Value::from(a + b);
    }).expect("bad");
    instance.set_global_callback("ShellAPI", "sub_numbers", |args| {
        let a: i32 = args[0].clone().try_into().unwrap();
        let b: i32 = args[1].clone().try_into().unwrap();

        return Value::from(a - b);
    }).expect("bad");
}