FROM ros:noetic

RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-noetic-gmapping \
    git \
    ros-noetic-joy \
    ros-noetic-teleop-twist-joy \
    ros-noetic-teleop-twist-keyboard \
    ros-noetic-amcl \
    ros-noetic-map-server \
    ros-noetic-move-base \
    ros-noetic-urdf \
    ros-noetic-xacro \
    ros-noetic-rqt-image-view \
    ros-noetic-gmapping \
    ros-noetic-navigation \
    ros-noetic-joint-state-publisher \
    ros-noetic-robot-state-publisher \
    ros-noetic-slam-gmapping \
    ros-noetic-dwa-local-planner \
    ros-noetic-rviz \
    ros-noetic-joint-state-publisher-gui \
    libvmmalloc-dev \
    libraspberrypi-bin \
    libraspberrypi-dev \
    python3-dev \
    python3-rpi.gpio

RUN apt-get update && apt-get install -y --no-install-recommends \
   python3-wstool \ 
   python3-rosdep \ 
   ninja-build stow

# Make the prompt a little nicer
RUN echo "PS1='${debian_chroot:+($debian_chroot)}\u@:\w\$ '" >> /etc/bash.bashrc 
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /etc/bash.bashrc

# RUN mkdir -p /docker
RUN mkdir -p /catkin_ws/src
RUN mkdir -p /catkin_ws/carto_ws/src

# Set the working directory
WORKDIR /catkin_ws

RUN git clone -b noetic --recursive https://github.com/rigbetellabs/tortoisebot.git /catkin_ws/src/tortoisebot

RUN rm -rf /catkin_ws/src/tortoisebot/raspicam_node
RUN rm -rf /catkin_ws/src/tortoisebot/tortoisebot_gazebo

RUN rosdep update
RUN rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y

# Set the working directory
WORKDIR /catkin_ws/carto_ws
COPY custom.rosinstall /catkin_ws/carto_ws/src

RUN wstool init src
RUN wstool merge -t src /catkin_ws/carto_ws/src/custom.rosinstall
RUN wstool update -t src
#RUN sudo rosdep init
RUN rosdep update

RUN git clone -b melodic-devel https://github.com/ros-perception/perception_pcl.git /carto_ws/src/perception_plc
RUN git clone https://github.com/ros-perception/pcl_msgs /carto_ws/src/pcl_msgs
RUN git clone -b noetic-devel https://github.com/jsk-ros-pkg/geometry2_python3.git /carto_ws/src/geometry2_python3

RUN src/cartographer/scripts/install_abseil.sh

RUN rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y

# Copy the generate_map.launch file
COPY generate_map.launch /catkin_ws/carto_ws/src/cartographer_ros/cartographer_ros/launch


RUN /bin/bash -c "source /opt/ros/$ROS_DISTRO/setup.bash && catkin_make_isolated --install --use-ninja -j1 -l1"

RUN /bin/bash -c "cd /catkin_ws/carto_ws && source devel_isolated/setup.bash"


#RUN rm -rf /catkin_ws/src/tortoisebot/tortoisebot_control
#RUN rm -rf /catkin_ws/src/tortoisebot/tortoisebot_gazebo
#RUN rm -rf /catkin_ws/src/tortoisebot/tortoisebot_firmware
#RUN rm -rf /catkin_ws/src/tortoisebot/raspicam_node
#RUN rm -rf /catkin_ws/src/tortoisebot/tortoisebot_gazebo

#RUN rm -rf /catkin_ws/src/tortoisebot/tortoisebot_description
#RUN rm -rf /catkin_ws/src/tortoisebot/ydlidar_ros

# RUN mv /docker/tortoisebot /catkin_ws/src/
# RUN rm -rf /docker

WORKDIR /catkin_ws

# Clean the build and devel folders
RUN /bin/bash -c "cd /catkin_ws && rm -rf build devel"

# Build the workspace and source the setup script
RUN /bin/bash -c "cd /catkin_ws && source /opt/ros/$ROS_DISTRO/setup.bash && catkin_make && source devel/setup.bash"

RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /etc/bash.bashrc
ADD overlay.sh /

ENTRYPOINT ["bash", "/overlay.sh"]
CMD ["roslaunch", "cartographer_ros generate_map.launch"]
