# Viewing this site on your phone

The game is static HTML/CSS/JS, so you just need a small web server running on
your computer and a URL your phone can reach.

## Easiest: same Wi-Fi (free, no accounts)

1. On your computer, in this folder, run:
   ```
   ./serve.sh
   ```
   (Windows: use WSL, or run `python3 -m http.server 8000` inside the
   `murder to go` folder.)
2. Make sure your phone is on the **same Wi-Fi** as the computer.
3. Open the `http://<your-ip>:8000` URL the script prints, in your phone's browser.

If it doesn't load, your computer's firewall may be blocking the port — allow
incoming connections for Python, or temporarily allow the port.

## From anywhere: a tunnel (temporary public URL)

Useful for showing someone on cellular. Pick one:

- **ngrok:** `ngrok http 8000`
- **Cloudflare:** `cloudflared tunnel --url http://localhost:8000`
- **VS Code:** "Forward a Port" (built in)

Each prints an `https://…` URL anyone can open. The URL is public while it runs.

## Private + stable: Tailscale

[Tailscale](https://tailscale.com) is a private mesh VPN. Install it on your
computer **and** your phone, sign in with the same account, then open
`http://<computer's-tailscale-ip>:8000`. Works from anywhere, stays private
(not exposed to the public internet), and the address doesn't change. Best
option if you'll do this regularly.

## MAMP virtual-host sites (e.g. `veith.virtual.local`)

MAMP serves sites by **name-based virtual host**, so two things must be true for
another device to load one:

1. The hostname must resolve to the Mac's IP.
2. The HTTP request must carry that hostname (so Apache picks the right vhost).

Editing `/etc/hosts` solves both on a laptop, but iOS won't let you edit it.
The trick for the phone is a wildcard-DNS service — [sslip.io](https://sslip.io)
resolves `<any-labels>.<ip-with-dashes>.sslip.io` to that IP, including your
Mac's Tailscale IP — combined with a `ServerAlias`.

Worked example for `https://veith.virtual.local:8890`:

1. Get the Mac's Tailscale IP (run on the Mac):
   ```
   tailscale ip -4          # e.g. 100.64.1.5
   ```
2. The sslip.io hostname (dots → dashes only in the IP part):
   ```
   veith.virtual.100-64-1-5.sslip.io
   ```
3. Add the alias to that site's vhost in `httpd-vhosts.conf`, then restart MAMP:
   ```apache
   <VirtualHost *:8890>
     ServerName  veith.virtual.local
     ServerAlias veith.virtual.100-64-1-5.sslip.io
     DocumentRoot "/your/path/to/veith"
     # ...your existing SSL directives stay...
   </VirtualHost>
   ```
4. On the phone (on the same tailnet), open — keeping scheme and port:
   ```
   https://veith.virtual.100-64-1-5.sslip.io:8890
   ```

**HTTPS note:** the MAMP cert is issued for `veith.virtual.local`, not the
sslip.io name, so the browser shows a certificate-mismatch warning. Tap
*Show Details → visit this website* to proceed (safe for a local dev cert).
To avoid it, use plain `http://…` on MAMP's non-SSL port, or later issue a cert
that lists the sslip.io name as a Subject Alternative Name.

On other Macs/PCs (not iPhone) you can skip sslip.io and just add the name to
that machine's `/etc/hosts`, pointing at the Mac's Tailscale IP:

```
100.64.1.5   veith.virtual.local
```

## Notes

- Chrome sync (signing into the same Google account on both devices) syncs tabs
  and bookmarks, but does **not** give your phone network access to a
  `localhost`/LAN URL — you still need one of the methods above.
