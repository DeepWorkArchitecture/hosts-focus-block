# hosts-focus-block

Block distracting sites on your work machine through the hosts file, so switching the block off takes a deliberate command instead of one click.

```console
$ sudo ./block-distractions.sh
Dev-Execution block active.

$ ping -c 1 reddit.com
PING reddit.com (127.0.0.1) ...
```

It adds friction and makes no claim to be security. Anyone with admin rights, including you, can undo it in seconds. The point is the pause: a browser extension is off in one click when you're bored, and this needs a command you have to mean.

Works on **Windows** (PowerShell), **macOS** and **Linux**. No dependencies.

## How it works

The script writes a marked section to your hosts file that points each domain (and its `www.` version) at `127.0.0.1`, then flushes the DNS cache:

```
# >>> dev-execution-block >>>
127.0.0.1 reddit.com
127.0.0.1 www.reddit.com
...
# <<< dev-execution-block <<<
```

Running it again replaces its own section rather than adding a second one. Unblocking removes only the lines between the markers, and the rest of your hosts file stays as it was.

## Files

| File | Platform | Does |
|---|---|---|
| `block-distractions.sh` | macOS, Linux | Adds the block |
| `unblock-distractions.sh` | macOS, Linux | Removes the block |
| `block-distractions.ps1` | Windows | Adds the block, or removes it with `-Unblock` |

## 1. Edit the domain list

The default list is:

```
twitter.com  x.com  reddit.com  news.ycombinator.com
facebook.com  instagram.com  youtube.com
```

Remove anything you need for work, and add whatever you lose time to.
- macOS/Linux: the `DOMAINS=( ... )` lines in `block-distractions.sh`
- Windows: the `$domains =` line in `block-distractions.ps1`

## 2. Back up your hosts file (once)

**macOS / Linux**
```sh
sudo cp /etc/hosts /etc/hosts.original
```

**Windows** (PowerShell as Administrator)
```powershell
Copy-Item "$env:SystemRoot\System32\drivers\etc\hosts" "$env:SystemRoot\System32\drivers\etc\hosts.original"
```

The shell scripts also write `/etc/hosts.bak` on every run, but that copy is replaced each time, so keep `hosts.original` as your real backup.

## 3. Block

**macOS / Linux**
```sh
chmod +x block-distractions.sh unblock-distractions.sh
sudo ./block-distractions.sh
```

**Windows** (PowerShell as Administrator, in this folder)
```powershell
powershell -ExecutionPolicy Bypass -File .\block-distractions.ps1
```

`-ExecutionPolicy Bypass` applies to this one run only and doesn't change your system settings.

## 4. Unblock

**macOS / Linux**
```sh
sudo ./unblock-distractions.sh
```

**Windows**
```powershell
powershell -ExecutionPolicy Bypass -File .\block-distractions.ps1 -Unblock
```

## If a blocked site still loads

- Quit the browser completely and reopen it. Browsers cache DNS.
- In Chrome, open `chrome://net-internals/#dns` and click **Clear host cache**.
- Browsers using secure DNS (DNS over HTTPS) can skip the hosts file. Firefox is the most common case. Check the browser's secure DNS setting.
- A VPN or a custom DNS setup can also bypass it.
- It only affects the machine you run it on, not your phone.

## Restore your backup

**macOS**
```sh
sudo cp /etc/hosts.original /etc/hosts
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
```

**Linux**
```sh
sudo cp /etc/hosts.original /etc/hosts
resolvectl flush-caches   # or restart if resolvectl isn't available
```

**Windows** (PowerShell as Administrator)
```powershell
Copy-Item "$env:SystemRoot\System32\drivers\etc\hosts.original" "$env:SystemRoot\System32\drivers\etc\hosts" -Force
ipconfig /flushdns
```

You can also open the hosts file as administrator and delete everything between the two marker lines, markers included.

## Notes

- **Work laptops:** if your employer manages the machine, check with IT before editing the hosts file.
- **Antivirus** may warn that the hosts file changed. That's expected here.
- **Testing:** the scripts have been tested against copies of hosts files. If something behaves differently on your system, please open an issue with your OS and shell version.

## Why this exists

This is Day 1 of a 14-day focus protocol for software engineers. The other days cover a separate work profile, getting the phone off the desk, two fixed times to read messages, focus blocks and a shutdown routine. If you want the rest, there's a free 17-page starter kit: <https://whop.com/c/the-dopamine-reset-protocol-free-starter-kit/github>

## License

MIT. See [LICENSE](LICENSE).
