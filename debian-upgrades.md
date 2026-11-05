# Enabling unattended upgrades on Debian

Enabling unattended upgrades on Debian turns out to be surprisingly more difficult than it should. There's no one-step process.

The official doc is at <https://wiki.debian.org/PeriodicUpdates>.

It becomes essential to do from the security standpoint. Here go my instructions.

Install the relevant package

```bash
sudo apt update; sudo apt install unattended-upgrades
```

Run the following and select "yes"

```bash
sudo dpkg-reconfigure unattended-upgrades
```

Verify the contents of the following file:

```bash
cat /etc/apt/apt.conf.d/20auto-upgrades
## Should output
# APT::Periodic::Update-Package-Lists "1";
# APT::Periodic::Unattended-Upgrade "1";
## without comments
```

Create a copy of the config file for customization

```bash
sudo cp -iv /etc/apt/apt.conf.d/50unattended-upgrades /etc/apt/apt.conf.d/52unattended-upgrades-local
```

Edit the configuration

```bash
sudo nano /etc/apt/apt.conf.d/52unattended-upgrades-local
```

1. For Debian, in `Unattended-Upgrade::Origins-Pattern`, others should be commented out:

    ```plain
    "origin=Debian,codename=${distro_codename}-updates";
    "origin=Debian,codename=${distro_codename},label=Debian";
    "origin=Debian,codename=${distro_codename},label=Debian-Security";
    "origin=Debian,codename=${distro_codename}-security,label=Debian-Security";
    ```

2. For Ubuntu, in `Unattended-Upgrade::Allowed-Origins`, others commented out:

    ```plain
    "${distro_id}:${distro_codename}";
    "${distro_id}:${distro_codename}-security";
    "${distro_id}ESMApps:${distro_codename}-apps-security";
    "${distro_id}ESM:${distro_codename}-infra-security";
    "${distro_id}:${distro_codename}-updates";
    ```

3. If the box is meant to be a server running unattended, enable automatic reboots. Find, uncomment and set these:

    ```plain
    Unattended-Upgrade::Automatic-Reboot "true";
    Unattended-Upgrade::Automatic-Reboot-WithUsers "true";
    ```

Run the tool in dry-run mode and check if it does something that may look like upgrades or produces errors.

```bash
sudo unattended-upgrade --dry-run --debug
```

Update download schedule to happen at night:

```bash
sudo systemctl edit apt-daily.timer
```

Paste the following between comments and save:

```ini
[Timer]
OnCalendar=
OnCalendar=01:00
RandomizedDelaySec=2h
Persistent=true
```

If needed, check the effective contents and the next scheduled run:

```bash
sudo systemctl cat apt-daily.timer
sudo systemctl status apt-daily.timer
```

Similarly with install schedule to happen after downloads:

```bash
sudo systemctl edit apt-daily-upgrade.timer
```

Paste the following:

```ini
[Timer]
OnCalendar=
OnCalendar=03:30
RandomizedDelaySec=60m
Persistent=true
```

Check:

```bash
sudo systemctl cat apt-daily-upgrade.timer
sudo systemctl status apt-daily-upgrade.timer
```

Now, verify the respective services work.

Remove timestamp files to make the updates actually run:

```bash
sudo rm -fv /var/lib/apt/periodic/*-stamp
```

Run `apt update` through the service and check logs.

```bash
sudo systemctl start --wait apt-daily.service
sudo journalctl -u apt-daily.service --since "1h ago"
sudo less -r /var/log/unattended-upgrades/unattended-upgrades.log
```

Run `apt upgrade` through the service and check logs.\
Not that it may restart the box, that's expected.\
We run explicit `apt upgrade --assume-no` to verify there's some delta before and after.

```bash
sudo apt upgrade --assume-no
sudo systemctl start --wait apt-daily-upgrade.service
sudo journalctl -u apt-daily-upgrade.service --since "1h ago"
sudo less -r /var/log/unattended-upgrades/unattended-upgrades-dpkg.log
sudo apt upgrade --assume-no
```

In a day, come back and check logs:

```bash
sudo ls -la /var/log/unattended-upgrades
sudo less -r /var/log/unattended-upgrades/unattended-upgrades.log
sudo less -r /var/log/unattended-upgrades/unattended-upgrades-dpkg.log
```
