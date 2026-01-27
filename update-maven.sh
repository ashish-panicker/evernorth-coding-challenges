#!/bin/bash

set -e

MAVEN_VERSION=3.9.12
MAVEN_ARCHIVE=apache-maven-${MAVEN_VERSION}-bin.tar.gz
MAVEN_URL=https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/${MAVEN_ARCHIVE}

INSTALL_BASE=/opt
MAVEN_DIR=${INSTALL_BASE}/apache-maven-${MAVEN_VERSION}
MAVEN_SYMLINK=${INSTALL_BASE}/apache-maven
PROFILE_FILE=/etc/profile.d/maven.sh
BASHRC_FILE=$HOME/.bashrc

echo "=============================="
echo " Upgrading Apache Maven"
echo "=============================="

# 1. Remove old Maven installed via apt
if dpkg -l | grep -q "^ii  maven "; then
  echo "Removing old Maven installed via apt..."
  sudo apt remove -y maven
else
  echo "No apt-based Maven installation found."
fi

# 2. Remove old mvn binary if present
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

# 6. Set ownership
echo "Setting ownership..."
sudo chown -R "$USER":"$USER" "$MAVEN_DIR"

# 7. Create /opt/apache-maven symlink
echo "Updating Maven symlink..."
sudo ln -sfn "$MAVEN_DIR" "$MAVEN_SYMLINK"

# 8. Create Maven environment file
echo "Creating Maven environment file..."
sudo tee "$PROFILE_FILE" > /dev/null <<EOF
# Apache Maven Environment Variables
export MAVEN_HOME=${MAVEN_SYMLINK}
export PATH=\${MAVEN_HOME}/bin:\${PATH}
EOF

# 9. Ensure /etc/profile is sourced from ~/.bashrc (Linux Mint fix)
if ! grep -q "/etc/profile" "$BASHRC_FILE"; then
  echo "Updating ~/.bashrc to load /etc/profile..."
  cat <<EOF >> "$BASHRC_FILE"

# Load system-wide environment variables (Maven, Java, etc.)
if [ -f /etc/profile ]; then
    source /etc/profile
fi
EOF
else
  echo "/etc/profile already sourced in ~/.bashrc"
fi

# 10. Reload environment for current session
echo "Reloading environment..."
source /etc/profile
source "$BASHRC_FILE"
hash -r

# 11. Verify installation
echo "=============================="
echo " Maven Verification"
echo "=============================="
which mvn
mvn -v

echo "=============================="
echo " Maven upgrade completed!"
echo "=============================="
