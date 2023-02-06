@group(0)
@binding(0)
var<storage, read_write> v_pendulum_data: array<pendulum_data>;


struct pendulum_data{
    length: f32,
    mass: f32,
    angle: f32,
    angular_speed: f32,
};





fn collatz_iterations(pendulum:pendulum_data) -> pendulum_data{

    var force: f32 = sin(pendulum.angle)*pendulum.mass*1f;
    var acceleration: f32 = force/pendulum.mass;
    var new_angular_speed: f32 = pendulum.angular_speed + acceleration*0.0001f;
    var new_angle: f32 = pendulum.angle + new_angular_speed*0.0001f;

    
    return pendulum_data(pendulum.length, pendulum.mass, new_angle, new_angular_speed);
}

@compute
@workgroup_size(1)
fn main(@builtin(global_invocation_id) global_id: vec3<u32>) {

    var index: u32 = global_id.x* 10u+global_id.y;

    
    var pendulum: pendulum_data = v_pendulum_data[index];

    var result = collatz_iterations(pendulum);

    v_pendulum_data[index] = result;
    
}