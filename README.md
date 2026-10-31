cd ~/tb3-demo
cat > README.md <<'EOF'
# TurtleBot3 Burger on ROS 2 Jazzy + Gazebo Sim 8 (WSL2)

Debug notes and a direct-drive demo for a TurtleBot3 Burger simulation running on Windows + WSL2.

## Environment

| Item | Version |
|---|---|
| OS | Windows + WSL2 Ubuntu 24.04 |
| ROS 2 | Jazzy |
| Simulator | Gazebo Sim 8 |
| Robot | TurtleBot3 Burger |
| Navigation | Nav2 + RViz2 |
| Resources | 7.7 GB RAM, simulation runs at about 39% real-time |

## Quick start

Terminal 1: start the simulation

```bash
source /opt/ros/jazzy/setup.bash
export TURTLEBOT3_MODEL=burger
ros2 launch turtlebot3_gazebo turtlebot3_world.launch.py
```

Terminal 2: run the movement demo (Nav2 must be stopped)

```bash
cd ~/tb3-demo
bash demo_move.sh
```

The demo drives forward, spins left, drives forward again, then stops.

## Demo video

_Add link here._

## Findings

- **Command path works.** In Jazzy, `/cmd_vel` is `geometry_msgs/msg/TwistStamped`. The bridge maps it to `gz.msgs.Twist`. Odometry and `/scan` both change when commands are sent.
- **DiffDrive keeps its last velocity.** When the publisher stops, the robot keeps driving. A short burst of zeros may not be enough, so publish continuous zero velocity to stop it.
- **Do not use Gazebo's reset button.** After a reset, `/odom` stopped publishing. Relaunching Gazebo fixed it.
- **Odometry alone is not proof of motion.** Odom is computed from the commanded wheel velocities, so it can advance even if the robot is blocked. Cross-check with `/scan`: if the laser ranges change, the body moved.
- **Collision Monitor timeout is tight.** `scan.source_timeout` was 0.2 s. At low real-time factor the scans arrived 0.20 to 0.26 s late, so Nav2's Collision Monitor ignored them and zeroed the velocity. It can be raised at runtime:

```bash
ros2 param set /collision_monitor scan.source_timeout 2.0
```

The change is lost when Nav2 restarts.

## Status

- [x] Direct velocity commands reach the simulated robot (odom and laser scan confirm motion)
- [ ] Visible motion confirmed in the Gazebo window
- [ ] Nav2 goal reached. A goal still aborted after the timeout change, and the cause is under investigation.

## Useful checks

```bash
# who publishes and subscribes to /cmd_vel
ros2 topic info /cmd_vel --verbose

# live odometry position
ros2 topic echo /odom --once --field pose.pose.position
```

## Files

- `demo_move.sh`: direct-drive demo using `TwistStamped` on `/cmd_vel`
- `README.md`: this file
EOF
