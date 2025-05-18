## ✅ Setup Guide for Your Local Kubernetes Environment

Here’s a guide to install the main tools needed to work with Kubernetes on your local machine. Each tool plays an important role in the development and debugging process.

💡 Note: Each official website includes an installation guide tailored to different operating systems (Linux, macOS, Windows). Follow the instructions on the linked pages for your system.
---

### 🐳 Step 1: Install Docker Desktop

Docker lets you create and manage containers. It’s required for running Minikube, which uses Docker to simulate Kubernetes locally.

👉 [Download Docker Desktop](https://www.docker.com/)

---

### 🐳 Step 1.1: Install using the apt repository

Before you install Docker Engine for the first time on a new host machine, you need to set up the Docker apt repository. Afterward, you can install and update Docker from the repository.

1 - Set up Docker's apt repository.

```bash
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

```

2 - Install the Docker packages.

To install the latest version, run:

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

3 - Verify that the installation is successful by running the hello-world image:

```bash
sudo docker run hello-world
```

This command downloads a test image and runs it in a container. When the container runs, it prints a confirmation message and exits.

You have now successfully installed and started Docker Engine.


Tip: 

------------------------------------------------------------------------------------------------------------------------------------------------------------

Receiving errors when trying to run without root?

The docker user group exists but contains no users, which is why you’re required to use sudo to run Docker commands. Continue to Linux postinstall to allow non-privileged users to run Docker commands and for other optional configuration steps.

------------------------------------------------------------------------------------------------------------------------------------------------------------

### Linux post-installation steps for Docker Engine

These optional post-installation procedures describe how to configure your Linux host machine to work better with Docker.

Manage Docker as a non-root user
The Docker daemon binds to a Unix socket, not a TCP port. By default it's the root user that owns the Unix socket, and other users can only access it using sudo. The Docker daemon always runs as the root user.

If you don't want to preface the docker command with sudo, create a Unix group called docker and add users to it. When the Docker daemon starts, it creates a Unix socket accessible by members of the docker group. On some Linux distributions, the system automatically creates this group when installing Docker Engine using a package manager. In that case, there is no need for you to manually create the group.


! Warning:

----------------------------------------------------------------------------------------------------------------------------------------------------------------

The docker group grants root-level privileges to the user. For details on how this impacts security in your system, see Docker Daemon Attack Surface.

To run Docker without root privileges, see Run the Docker daemon as a non-root user (Rootless mode).

----------------------------------------------------------------------------------------------------------------------------------------------------------------

To create the docker group and add your user:

1 - Create the docker group.

```bash
 sudo groupadd docker
```

2 - Add your user to the docker group.

```bash
sudo usermod -aG docker $USER
```

3 - Log out and log back in so that your group membership is re-evaluated.

If you're running Linux in a virtual machine, it may be necessary to restart the virtual machine for changes to take effect.

You can also run the following command to activate the changes to groups:

```bash
newgrp docker
```

4 - Verify that you can run docker commands without sudo.

```bash
docker run hello-world
```

This command downloads a test image and runs it in a container. When the container runs, it prints a message and exits.

If you initially ran Docker CLI commands using sudo before adding your user to the docker group, you may see the following error:

WARNING: Error loading config file: /home/user/.docker/config.json -
stat /home/user/.docker/config.json: permission denied


This error indicates that the permission settings for the ~/.docker/ directory are incorrect, due to having used the sudo command earlier.

To fix this problem, either remove the ~/.docker/ directory (it's recreated automatically, but any custom settings are lost), or change its ownership and permissions using the following commands:

```bash
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R
```

### Configure Docker to start on boot with systemd

Many modern Linux distributions use systemd to manage which services start when the system boots. On Debian and Ubuntu, the Docker service starts on boot by default. To automatically start Docker and containerd on boot for other Linux distributions using systemd, run the following commands:

```bash
 sudo systemctl enable docker.service
 sudo systemctl enable containerd.service
```

To stop this behavior, use disable instead.

```bash
sudo systemctl disable docker.service
sudo systemctl disable containerd.service
```

You can use systemd unit files to configure the Docker service on startup, for example to add an HTTP proxy, set a different directory or partition for the Docker runtime files, or other customizations. For an example, see Configure the daemon to use a proxy.

### ⚙️ Step 2: Install Helm

Helm is a package manager for Kubernetes. It helps you install and manage applications on your cluster with simple commands.

👉 [Install Helm](https://helm.sh/docs/intro/install/)

---

### Installing Helm From Script


Helm now has an installer script that will automatically grab the latest version of Helm and install it locally.

You can fetch that script, and then execute it locally. It's well documented so that you can read through it and understand what it is doing before you run it.

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
```

```bash
$ chmod 700 get_helm.sh
```

```bash
$ ./get_helm.sh
```


###  Another Option From Apt (Debian/Ubuntu)

Members of the Helm community have contributed a Helm package for Apt. This package is generally up to date.

```bash
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

### 📦 Step 3: Install Minikube

Minikube allows you to run a local Kubernetes cluster. It’s great for development and testing before deploying to a real environment.

👉 [Install Minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Flinux%2Fx86-64%2Fstable%2Fbinary+download)


#### minikube start

minikube is local Kubernetes, focusing on making it easy to learn and develop for Kubernetes.

All you need is Docker (or similarly compatible) container or a Virtual Machine environment, and Kubernetes is a single command away: minikube start

* What you’ll need
* 2 CPUs or more
* 2GB of free memory
* 20GB of free disk space
* Internet connection
* Container or virtual machine manager, such as: Docker, QEMU, Hyperkit, Hyper-V, KVM, Parallels, Podman, VirtualBox, or VMware Fusion/Workstation

Installation:

```bash
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
```

Start your cluster:

```bash
minikube start
```

Interact with your cluster

If you already have kubectl installed (see documentation), you can now use it to access your shiny new cluster:

```bash
kubectl get po -A
```

Alternatively, minikube can download the appropriate version of kubectl and you should be able to use it like this:

```bash
minikube kubectl -- get po -A
```

You can also make your life easier by adding the following to your shell config: (for more details see: kubectl)

```bash
alias kubectl="minikube kubectl --"
```

Initially, some services such as the storage-provisioner, may not yet be in a Running state. This is a normal condition during cluster bring-up, and will resolve itself momentarily. For additional insight into your cluster state, minikube bundles the Kubernetes Dashboard, allowing you to get easily acclimated to your new environment:

```
minikube dashboard
```

Manage your cluster


Pause Kubernetes without impacting deployed applications:

```
minikube pause
```

Unpause a paused instance:

```
minikube unpause
```

Halt the cluster:

```
minikube stop
```

Change the default memory limit (requires a restart):

```
minikube config set memory 9001
```

Browse the catalog of easily installed Kubernetes services:

```
minikube addons list
```

Create a second cluster running an older Kubernetes release:

```
minikube start -p aged --kubernetes-version=v1.16.1
```
Delete all of the minikube clusters:

```
minikube delete --all
```


---

### 📡 Step 4: Install kubectl

`kubectl` is the command-line tool to interact with your Kubernetes cluster. You’ll use it to deploy apps, inspect resources, and more.

👉 [Install kubectl](https://pwittrock.github.io/docs/tasks/tools/install-kubectl/)


#### Before you begin


Use a version of kubectl that is the same version as your server or later. Using an older kubectl with a newer server might produce validation errors.

##### Install kubectl binary via curl


1. Download the latest release with the command:

```
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
```

To download a specific version, replace the $(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt) portion of the command with the specific version.

For example, to download version v1.7.0 on Linux, type:

```
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.7.0/bin/linux/amd64/kubectl
```

2. Make the kubectl binary executable.


```
chmod +x ./kubectl
```

3. Move the binary in to your PATH.

```
sudo mv ./kubectl /usr/local/bin/kubectl
```

#####  Install with snap on Ubuntu


kubectl is available as a snap application.

1. If you are on Ubuntu or one of other Linux distributions that support snap package manager, you can install with:

```
sudo snap install kubectl --classic
```

2. Run kubectl version to verify that the verison you’ve installed is sufficiently up-to-date

```
kubectl version
```


---

### 📺 Step 5: Install stern

Stern is a tool that helps you view logs from multiple pods in real time. It’s very useful for debugging apps running in Kubernetes.

👉 [Install stern](https://github.com/stern/stern)


####  Build from source

```
go install github.com/stern/stern@latest
```

#### asdf (Linux/macOS)
If you use asdf, you can install like this:

```
asdf plugin-add stern
asdf install stern latest
```

---


#### Homebrew (Linux/macOS)

If you use Homebrew, you can install like this:

```
brew install stern
```

### HomeBrew installation on Ubuntu Linux


1. Open a command terminal
Run terminal and then first, issue an update command-

```
sudo apt update

sudo apt-get install build-essential
```

2. Install Git on Ubuntu 20.04
For setting up LinuxBrew on Ubuntu, we need to install GIT on our system, here is the command for that…

```
sudo apt install git -y
```

3. Run Homebrew installation script

The official website of Brew offers a pre-build script to install download and install Homebrew using the command line on any available Linux such as CentOS, RHEL, OpenSUSE, Linux Mint, Kali, MX Linux, POP!OS and others.

Here is the command, just run it-

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

4. Add Homebrew to your PATH
To run the brew command after installation, we need to add it to our system path…

```
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

5. Check Brew is working fine
To ensure everything is working correctly to use brew, we can run its command-

```
brew doctor
```

It may give the warning to install GCC and to remove that simply install it using brew-

```
brew install gcc
```

6. Uninstall it from Linux
If you want to remove Homebrew, then here is the brew uninstallation script, also available on GitHub.

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
```



### 🧭 Step 6: Install k9s

K9s is a terminal-based UI to manage your Kubernetes cluster. It’s a quick and easy way to explore resources and see what’s happening.

👉 [Install k9s](https://k9scli.io/topics/install/)


#### Overview

K9s is available on Linux, macOS and Windows platforms.

Binaries for Linux, Windows and Mac are available as tarballs in the release page.


* MacOS

```
 # Via Homebrew
 brew install derailed/k9s/k9s
 # Via MacPort
 sudo port install k9s
```

* Linux

```
 # Via LinuxBrew
 brew install derailed/k9s/k9s
 # Via PacMan
 pacman -S k9s
```

#### PreFlight Check

* K9s uses 256 colors terminal mode. On `Nix system make sure TERM is set accordingly.


```
export TERM=xterm-256color
```

* In order to issue resource edit commands make sure your EDITOR and/or KUBE_EDITOR env vars are set.

```
 # Kubectl edit command will use this env var.
  export KUBE_EDITOR=my_fav_editor
```


