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

# RUN mkdir -p /docker
RUN mkdir -p /catkin_ws/src

RUN git clone -b noetic --recursive https://github.com/rigbetellabs/tortoisebot.git /catkin_ws/src/tortoisebot

RUN rosdep update
RUN rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y

RUN mkdir ~/carto_ws
RUN cd ~/carto_ws
RUN wstool init src
RUN wstool merge -t src https://raw.githubusercontent.com/cartographer-project/cartographer_ros/master/cartographer_ros.rosinstall
RUN wstool update -t src
RUN sudo rosdep init
RUN rosdep update
RUN rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y

RUN cd ~/carto_ws/src
RUN git clone -b melodic-devel https://github.com/ros-perception/perception_pcl.git
RUN git clone https://github.com/ros-perception/pcl_msgs
RUN git clone -b noetic-devel https://github.com/jsk-ros-pkg/geometry2_python3.git

RUN cd ~/carto_ws/
RUN rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y
RUN src/cartographer/scripts/install_abseil.sh
RUN catkin_make_isolated --install --use-ninja -j4 -l4

# RUN git clone https://github.com/rg-masterclass/docker.git /docker
#if you face a problem, do the following:

#RUN rm -rf /catkin_ws/src/tortoisebot/tortoisebot_control
#RUN rm -rf /catkin_ws/src/tortoisebot/tortoisebot_gazebo
#RUN rm -rf /catkin_ws/src/tortoisebot/tortoisebot_firmware
#RUN rm -rf /catkin_ws/src/tortoisebot/raspicam_node
#RUN rm -rf /catkin_ws/src/tortoisebot/tortoisebot_description
#RUN rm -rf /catkin_ws/src/tortoisebot/ydlidar_ros

# RUN mv /docker/tortoisebot /catkin_ws/src/
# RUN rm -rf /docker

ADD ros_entrypoint.sh /

WORKDIR /catkin_ws

RUN sudo rosdep init
RUN rosdep update
RUN rosdep install --from-paths src --ignore-src -r -y

COPY mapping.launch /catkin_ws/src/tortoisebot/tortoisebot_slam/launch/

RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /etc/bash.bashrc

RUN /bin/bash -c 'source /opt/ros/$ROS_DISTRO/setup.bash &&\
catkin_make --directory /catkin_ws -DCMAKE_BUILD_TYPE=Debug'

RUN echo "source /catkin_ws/devel/setup.bash" >> /etc/bash.bashrc

ENTRYPOINT ["bash", "/overlay.sh"]
#CMD ["roslaunch", "tortoisebot_slam mapping.launch"]