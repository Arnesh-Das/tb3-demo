source /opt/ros/jazzy/setup.bash
pub(){ timeout $1 ros2 topic pub -r 10 /cmd_vel geometry_msgs/msg/TwistStamped "$2" > /dev/null 2>&1; }
echo Forward; pub 6 "{twist: {linear: {x: 0.15}}}"
echo Spin; pub 8 "{twist: {angular: {z: 0.6}}}"
echo Forward; pub 6 "{twist: {linear: {x: 0.15}}}"
echo Stop; pub 4 "{twist: {}}"
