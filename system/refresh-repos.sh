# Update required CITE repositories, and demo data repository.
# - easy_cts_archive


GIT=`which git`
echo git installed at $GIT

# This script is repsonsible for cloning or updating all HMT git repositories
# needed for editing.
#
# It's up to individual editors to maintain their own repository
# for editorial content.
#

if [ -d "/vagrant/cs2" ]; then
    echo "Checking for updates to cs2"
    cd /vagrant/cs2
    $GIT pull
else
    echo "Installing cs2"
    cd /vagrant
    echo  Running  $GIT clone
    https://github.com/cite-architecture/cs2.git
    $GIT clone https://github.com/cite-architecture/cs2.git
fi

if [ -d "/vagrant/cite-archive-manager" ]; then
    echo "Checking for updates to cite-archive-manager"
    cd /vagrant/cite-archive-manager
    $GIT pull
else
    echo "Installing cite-archive-manager"
    cd /vagrant
    echo  Running  $GIT clone     https://github.com/cite-architecture/cite-archive-manager.git
    $GIT clone https://github.com/cite-architecture/cite-archive-manager.git
fi


if [ -d "/vagrant/easy_cts_archive" ]; then
    echo "Checking for updates to easy_cts_archive"
    cd /vagrant/easy_cts_archive
    $GIT pull
    cp /vagrant/easy_cts_archive/manager-conf.gradle /vagrant/cite-archive-manager/conf.gradle
else
    echo "Installing easy_cts_archive"
    cd /vagrant
    echo  Running  $GIT clone
    https://github.com/cite-architecture/easy_cts_archive.git

    $GIT clone https://github.com/cite-architecture/easy_cts_archive.git
    cp /vagrant/easy_cts_archive/manager-conf.gradle /vagrant/cite-archive-manager/conf.gradle
fi
