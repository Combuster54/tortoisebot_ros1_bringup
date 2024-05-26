#!/bin/bash
set -e

# setup ros environment
source /opt/ros/$ROS_DISTRO/setup.bash
source /catkin_ws/devel/setup.bash
source /carto_ws/devel/setup.bash

sleep 1s

$@