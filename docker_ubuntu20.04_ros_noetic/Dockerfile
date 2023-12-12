FROM ubuntu:20.04
############################## SYSTEM PARAMETERS ##############################
# * Arguments
ARG USER=initial
ARG GROUP=initial
ARG UID=1000
ARG GID=${UID}
ARG SHELL=/bin/bash
ARG HARDWARE=x86_64
ARG ENTRYPOINT_FILE=entrypint.sh

# * Env vars for the nvidia-container-runtime.
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES all
# ENV NVIDIA_DRIVER_CAPABILITIES graphics,utility,compute

# * Setup users and groups
RUN groupadd --gid ${GID} ${GROUP} \
    && useradd --gid ${GID} --uid ${UID} -ms ${SHELL} ${USER} \
    && mkdir -p /etc/sudoers.d \
    && echo "${USER}:x:${UID}:${UID}:${USER},,,:$HOME:${shell}" >> /etc/passwd \
    && echo "${USER}:x:${UID}:" >> /etc/group \
    && echo "${USER} ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/${USER}" \
    && chmod 0440 "/etc/sudoers.d/${USER}"

# * Replace apt urls
# ? Change to tku
RUN sed -i 's@archive.ubuntu.com@ftp.tku.edu.tw@g' /etc/apt/sources.list
# ? Change to Taiwan
# RUN sed -i 's@archive.ubuntu.com@tw.archive.ubuntu.com@g' /etc/apt/sources.list

# T
ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
############################### INSTALL #######################################
# * Install packages
RUN apt update \
    && apt-get install -y --no-install-recommends \
        sudo \
        git \
        htop \
        wget \
        curl \
        psmisc \
        # * Shell
        byobu \
        terminator \
        # * base tools
        python3-pip \
        python3-dev \
        python3-setuptools \
        # * Work tools
        # * ROS depend tools
        lsb-release \
        gnupg \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
# * Install ROS noetic

RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > \
    /etc/apt/sources.list.d/ros-latest.list \
    && apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' \
    --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 \
    && curl -sSL \
    'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654' \
    | sudo apt-key add - \
    && apt update && apt install -y --no-install-recommends ros-noetic-desktop-full \
    && apt-get clean \
    && apt install ros-noetic-velocity-controllers \
    && rm -rf /var/lib/apt/lists/*

ENV ROS_DISTRO noetic
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >>/home/$USER/.bashrc

RUN apt update \
    && apt-get install -y --no-install-recommends \
    	build-essential \
    	ros-noetic-joy ros-noetic-teleop-twist-joy \
  	ros-noetic-teleop-twist-keyboard ros-noetic-laser-proc \
  	ros-noetic-rgbd-launch ros-noetic-rosserial-arduino \
  	ros-noetic-rosserial-python ros-noetic-rosserial-client \
  	ros-noetic-rosserial-msgs ros-noetic-amcl ros-noetic-map-server \
  	ros-noetic-move-base ros-noetic-urdf ros-noetic-xacro \
  	ros-noetic-compressed-image-transport ros-noetic-rqt* ros-noetic-rviz \
  	ros-noetic-gmapping ros-noetic-navigation ros-noetic-interactive-markers \
  	ros-noetic-dynamixel-sdk \
  	ros-noetic-turtlebot3-msgs \
  	ros-noetic-turtlebot3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Ceres Solver installed to /usr/local/libname
RUN apt update \
    && apt-get install -y --no-install-recommends \
    	cmake \
    	libgoogle-glog-dev \
    	libgflags-dev \
    	libatlas-base-dev \
    	libeigen3-dev \
    	libsuitesparse-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://ceres-solver.googlesource.com/ceres-solver \
    && sudo mkdir ceres-bin \
    && cd ceres-bin \
    && cmake ../ceres-solver \
    && make -j3 \
    && make test \
    && make install
# g2o installed to default path
RUN apt update \
    &&apt-get install ros-noetic-libg2o 

#Sophus installed to /usr/local/libname
#RUN sh -c "su - ${USER} -c 'git clone https://github.com/strasdat/Sophus.git /home/$USER/Sophus1'" 
#RUN git clone https://github.com/strasdat/Sophus.git
#RUN cd /home/$USER/Sophus1
#RUN ls -la
#RUN cd Sophus
   #&&ls -la /home/$USER/
    ##&& git checkout a621ff \
    ##&& mkdir -p build && cd build \
    ##&& cmake -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=/usr/local/Sophus .. \
    ##&& cd sophus \
    ##&& sed -i 's/unit_complex_.real() = 1.; unit_complex_.imag() = 0.;/auto temp_real = 1.;unit_complex_.real(temp_real);auto temp_imag = 0.;unit_complex_.imag(temp_imag);/' so2.cpp \
    ##&& cd .. \
    ##&& make -j12 \
    ##&& make install \
    ##&& cd .. && sudo rm -r ./build

#install opencv      
RUN apt install -y libopencv-dev python3-opencv
#install DBow3
RUN git clone https://github.com/rmsalinas/DBow3 \
    && cd DBow3 \
    && mkdir -p build && cd build \
    && cmake -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=/usr/local/DBow3 .. \
    && make -j12 \
    && sudo make install \
    && cd ..&& sudo rm -r ./build
#install A-LOAM



 
    

    


	


# gnome-terminal libcanberra-gtk-module libcanberra-gtk3-module \
# dbus-x11 libglvnd0 libgl1 libglx0 libegl1 libxext6 libx11-6 \

############################### INSTALL #######################################
# * Switch workspace to /home/${USER}/.tmp
WORKDIR /home/${USER}/.tmp


# * Copy custom configuration
COPY config .

RUN bash ./script/shell_setup.sh \
    "bash" ${ROS_TYPE} ${ROS_MASTER_IP} ${ROS_SLAVE_IP} \
    && bash ./script/pip_setup.sh \
    && rm -rf /home/${USER}/.tmp

# * Copy entrypoint
COPY --chmod=0775 ./${ENTRYPOINT_FILE} /entrypoint.sh

# * Switch workspace to /home/${USER}
WORKDIR /home/${USER}

# * Switch user to ${USER}
USER ${USER}
RUN sudo mkdir work

# * Make SSH available
EXPOSE 22

# * Switch workspace to ~/work
WORKDIR /home/${USER}/work



ENTRYPOINT [ "/entrypoint.sh", "terminator" ]
# ENTRYPOINT [ "/entrypoint.sh", "byobu" ]
# ENTRYPOINT [ "/entrypoint.sh", "bash" ]
# ENTRYPOINT [ "/entrypoint.sh" ]
