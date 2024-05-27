#!/bin/bash
set -e

# setup ros environment
source /opt/ros/$ROS_DISTRO/setup.bash
cd /catkin_ws/carto_ws
source devel_isolated/setup.bash
cd ..
source devel/setup.bash

sleep 1s

$@
