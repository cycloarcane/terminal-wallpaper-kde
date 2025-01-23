# Cool ASCII & CLI Tricks for Arch Linux

## 1. ASCII Matrix (Hacker Style)
```bash
cmatrix -a -b -u 5
```
**Install:**  
```bash
sudo pacman -S cmatrix
```
Adds a cascading Matrix-like effect.

## 2. ASCII Fire
```bash
aafire
```
**Install:**  
```bash
sudo pacman -S aalib
```
Displays a cool ASCII fire animation.

## 3. ASCII Aquarium
```bash
asciiquarium
```
**Install:**  
```bash
yay -S asciiquarium
```
Displays an animated ASCII aquarium.

## 4. Random ASCII Art
```bash
while true; do toilet -f mono12 "Arch Linux" --gay; sleep 2; clear; done
```
**Install:**  
```bash
sudo pacman -S toilet
```
Generates colorful ASCII text effects.

## 5. Clock with ANSI Art
```bash
tty-clock -s -c -C 6
```
**Install:**  
```bash
sudo pacman -S tty-clock
```
Shows a stylish clock with ANSI colors.

## 6. Colorful Logs Scrolling
```bash
journalctl -f | lolcat
```
**Install:**  
```bash
sudo pacman -S lolcat
```
Displays live system logs in rainbow colors.

# Useful / Productivity

## 7. Live System Stats
```bash
btop
```
**Install:**  
```bash
sudo pacman -S btop
```
A beautiful, interactive system monitor.

## 8. Weather Forecast
```bash
curl wttr.in
```
Fetches a weather report.

## 9. Random Quotes
```bash
fortune | cowsay | lolcat
```
**Install:**  
```bash
sudo pacman -S fortune-mod cowsay lolcat
```
Shows a random quote with a cow saying it.

## 10. Live Network Traffic Monitor
```bash
sudo iftop -i wlan0
```
**Install:**  
```bash
sudo pacman -S iftop
```
Monitors network usage in real-time.

## 11. Real-time World Map of Hackers
```bash
/lib/xscreensaver/mapscroller
```
**Install:**  
```bash
sudo pacman -S xscreensaver
```
Displays a scrolling ASCII world map.

## 12. Automated Web Scraper Fun
```bash
while true; do curl -s "https://www.reddit.com/r/unixporn/top/.json?limit=1" | jq -r '.data.children[0].data.title'; sleep 5; done
```
**Install:**  
```bash
sudo pacman -S jq
```
Fetches the top UnixPorn title every 5 seconds.
