set -e
#Sophus installed to /usr/local/libname
sudo apt-get update
sudo apt-get install -y --no-install-recommends 
git clone https://github.com/strasdat/Sophus.git
cd Sophus
git checkout a621ff
mkdir -p build && cd build
cmake -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=/usr/local/Sophus ..
cd .. && cd sophus
sed -i 's/ unit_complex_.real() = 1.;/ auto temp_real = 1.;unit_complex_.real(temp_real);/' so2.cpp 
sed -i 's/ unit_complex_.imag() = 0.;/ auto temp_imag = 0.;unit_complex_.imag(temp_imag);/' so2.cpp 
cd .. && cd build
sudo make -j12
sudo make install
cd .. && sudo rm -r ./build
cd ..
#A-LOAM
# cd src
#     git clone https://github.com/HKUST-Aerial-Robotics/A-LOAM.git
# cd ..
# catkin_make -DCATKIN_WHITELIST_PACKAGES="aloam_velodyne" --build='./build/A-LOAM' -DCATKIN_DEVEL_PREFIX=./devel -DCMAKE_INSTALL_PREFIX=./install  install




