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

## Notes

- Chrome sync (signing into the same Google account on both devices) syncs tabs
  and bookmarks, but does **not** give your phone network access to a
  `localhost`/LAN URL — you still need one of the methods above.
