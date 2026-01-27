#!/bin/bash

set -e

MAVEN_VERSION=3.9.12
MAVEN_ARCHIVE=apache-maven-${MAVEN_VERSION}-bin.tar.gz
MAVEN_URL=https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_ARCHIVE}

INSTALL_BASE=/opt
MAVEN_DIR=${INSTALL_BASE}/apache-maven-${MAVEN_VERSION}
MAVEN_SYMLINK=${INSTALL_BASE}/apache-maven
PROFILE_FILE=/etc/profile.d/maven.sh

echo "=============================="
echo " Upgrading Apache Maven"
echo "=============================="

# 1. Remove old Maven installed via apt (if any)
if dpkg -l | grep -q "^ii  maven "; then
  echo "Removing old Maven installed via apt..."
  sudo apt remove -y maven
else
  echo "No apt-based Maven installation found."
fi

# 2. Remove any existing Maven binaries from /usr/bin
if [ -L /usr/bin/mvn ] || [ -f /usr/bin/mvn ]; then
  echo "Removing old /usr/bin/mvn..."
  sudo rm -f /usr/bin/mvn
fi

# 3. Ensure /opt exists
if [ ! -d "$INSTALL_BASE" ]; then
  echo "Creating $INSTALL_BASE..."
  sudo mkdir -p "$INSTALL_BASE"
fi

# 4. Download Maven
if [ ! -f "$MAVEN_ARCHIVE" ]; then
  echo "Downloading Maven ${MAVEN_VERSION}..."
  wget "$MAVEN_URL"
else
  echo "Maven archive already exists."
fi

# 5. Extract Maven
if [ ! -d "$MAVEN_DIR" ]; then
  echo "Extracting Maven..."
  sudo tar -xvf "$MAVEN_ARCHIVE" -C "$INSTALL_BASE"
else
  echo "Maven already extracted."
fi

# 6. Set ownership for current user
echo "Setting ownership..."
sudo chown -R "$USER":"$USER" "$MAVEN_DIR"

# 7. Create /opt/apache-maven symlink (BEST PRACTICE)
echo "Updating Maven symlink..."
sudo ln -sfn "$MAVEN_DIR" "$MAVEN_SYMLINK"

# 8. Create environment variables
echo "Creating Maven environment file..."
sudo tee "$PROFILE_FILE" > /dev/null <<EOF
# Apache Maven Environment Variables
export MAVEN_HOME=${MAVEN_SYMLINK}
export PATH=\${MAVEN_HOME}/bin:\${PATH}
EOF

# 9. Reload environment
echo "Reloading environment..."
source "$PROFILE_FILE"
hash -r

# 10. Verify installation
echo "=============================="
echo " Maven Verification"
echo "=============================="
which mvn
mvn -v

echo "=============================="
echo " Maven upgrade completed!"
echo "=============================="
