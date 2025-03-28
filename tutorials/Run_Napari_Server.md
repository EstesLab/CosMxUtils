# Remote Desktop Setup for Napari on OHSU Servers

This guide explains how to configure SSH and VNC to access OHSU servers, launch a full desktop environment, and run Napari remotely.


## 1. Configure SSH on Your Local Machine

Edit your ~/.ssh/config file and add the following for access to OHSU servers:

```bash
Host monkeydo.ohsu.edu
    ProxyJump username@acc.ohsu.edu
    ForwardX11 yes
    ForwardX11Trusted yes

```

Replace "username" with your actual username.

Then, from your local machine, log in to monkeydo:

```bash
ssh username@monkeydo.ohsu.edu
```

## 2.  VNC Server on the Remote Machine

### a. First Time Setting up

if this you have already done these steps, skip to step f. !!

### b. Install then activate Conda env for Napari

Make sure you activate your appropriate conda environment (see Conda Napari tutorial). 

```bash
conda activate /path/to/your/napari-env
```

### c. Install a Tiger VNC server

```bash
sudo yum install tigervnc-server
```

#### Set the VNC Password

Each user (or the administrator for a shared session) needs to set a VNC password. Run the following command (as the user who will run the VNC server):

```bash
vncpasswd
```

You’ll be prompted to enter and verify a password. You can also set an optional view-only password if desired.

### d. Install a Desktop Environment

If this is your first time, install a full desktop environment. For example, to install XFCE on CentOS 7, run:

```bash
sudo yum groupinstall "Xfce"
```

### e. Configure VNC Startup

Edit the ~/.vnc/xstartup file on the remote machine. Use the following content:

```bash
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

# Start vncconfig if needed
vncconfig -iconic &

# Start a DBus daemon in the background, capture its address, and export it.
dbus-daemon --session --fork --print-address > /tmp/dbus_address
export DBUS_SESSION_BUS_ADDRESS=$(cat /tmp/dbus_address)

# Start XFCE
startxfce4 &
```

Make sure the xstartup file is executable:

```bash
chmod +x ~/.vnc/xstartup
```

### f. Start the VNC Server

Launch the VNC server on display :2 (which corresponds to port 5902):

```bash
vncserver -geometry 1000x1000 :2
```

To kill the VNC server, use:

```bash
vncserver -kill :2
```


## 3. Create an SSH Tunnel from Your Local Machine

In a new terminal on your local machine, create an SSH tunnel to forward the VNC port:

```bash
ssh -N -L 5902:127.0.0.1:5902 monkeydo.ohsu.edu
```

Note: The ":2" in the VNC server setup means the VNC server is running on port 5902 (5900 + 2).


## 4. Connect Using a VNC Viewer

On your local machine, open your VNC client. On macOS, go to Go > Connect to Server and enter:

```bash
vnc://127.0.0.1:5902
```

This will open a full desktop session from the remote server.


## 5. Launch Napari in the VNC Desktop

### a. Open a Terminal

In your desktop environment (XFCE or GNOME), open a terminal window from the application menu or desktop icons.

### b. Activate Your Napari Environment

If Napari is installed in a conda environment (e.g., "napari-env"), activate it by running:

```bash
conda activate /path/to/your/napari-env
```

Replace /path/to/your/napari-env with the actual path to your environment.

### c. Launch Napari

Once the environment is active, run:

```bash
napari
```

Napari should now launch within your VNC desktop session.

