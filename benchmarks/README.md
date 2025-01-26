# Benchmarks

## hagezi's blocklists overlapping

Overlapping between hagezi's Multi and TIF blocklists is small, and we shouldn't worry about it during the list import.

### Results

```sh
$ ./benchmark-multi_and_tif_overlapping.sh 
Blocklist tif-onlydomains-2025.0125.0149.35: 14M file with 706707 lines
Blocklist tif.mini-onlydomains-2025.0125.0226.33: 1.8M file with 98675 lines
Blocklist tif.medium-onlydomains-2025.0125.0218.17: 5.8M file with 305962 lines
Blocklist pro.mini-onlydomains-2025.0125.0322.25: 1.4M file with 76584 lines
Blocklist pro.plus.mini-onlydomains-2025.0125.0351.35: 1.6M file with 84503 lines

Dups    TIF_No  Multi_No        TIF     Multi
16306   706707  76584   tif-onlydomains-2025.0125.0149.35       pro.mini-onlydomains-2025.0125.0322.25
1804    305962  76584   tif.medium-onlydomains-2025.0125.0218.17        pro.mini-onlydomains-2025.0125.0322.25
1623    98675   76584   tif.mini-onlydomains-2025.0125.0226.33  pro.mini-onlydomains-2025.0125.0322.25
16344   706707  84503   tif-onlydomains-2025.0125.0149.35       pro.plus.mini-onlydomains-2025.0125.0351.35
1811    305962  84503   tif.medium-onlydomains-2025.0125.0218.17        pro.plus.mini-onlydomains-2025.0125.0351.35
1628    98675   84503   tif.mini-onlydomains-2025.0125.0226.33  pro.plus.mini-onlydomains-2025.0125.0351.35
```

## dnsmasq compact config

The more domains per line, the smaller the file size. I'm not sure, if there is a hard limit of line length. Someone on the internet restricted config file line length to 256 characters per line which looks like a conservative limit.

Randomly ordered domains gives us the shortest lines (in the long run). We can find the worst case scenario using as the input domains sorted in descending order (by length).

For wide range of hagezi's blocklists, 5 domains per line is a good tradeoff between config file size and line length.

### Selected results

```sh
$ ./benchmark.sh 'https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/light-onlydomains.txt' 2>/dev/null
Blocklist light-onlydomains-2025.0118.0940.58
domains only: 1.3M file with 69928 lines (longest line: 80 characters)
dnsmasq format with 1 domains per line:
 - original order: 1.8M file with 69928 lines (longest line: 89 characters)
 - descending order: 1.8M file with 69928 lines (longest line: 89 characters)
 - random order: 1.8M file with 69928 lines (longest line: 89 characters)
dnsmasq format with 2 domains per line:
 - original order: 1.6M file with 34964 lines (longest line: 159 characters)
 - descending order: 1.6M file with 34964 lines (longest line: 169 characters)
 - random order: 1.6M file with 34964 lines (longest line: 109 characters)
dnsmasq format with 3 domains per line:
 - original order: 1.5M file with 23310 lines (longest line: 228 characters)
 - descending order: 1.5M file with 23310 lines (longest line: 241 characters)
 - random order: 1.5M file with 23310 lines (longest line: 133 characters)
dnsmasq format with 4 domains per line:
 - original order: 1.4M file with 17482 lines (longest line: 295 characters)
 - descending order: 1.4M file with 17482 lines (longest line: 322 characters)
 - random order: 1.4M file with 17482 lines (longest line: 174 characters)
dnsmasq format with 5 domains per line:
 - original order: 1.4M file with 13986 lines (longest line: 362 characters)
 - descending order: 1.4M file with 13986 lines (longest line: 383 characters)
 - random order: 1.4M file with 13986 lines (longest line: 186 characters)
dnsmasq format with 6 domains per line:
 - original order: 1.4M file with 11655 lines (longest line: 416 characters)
 - descending order: 1.4M file with 11655 lines (longest line: 452 characters)
 - random order: 1.4M file with 11655 lines (longest line: 211 characters)
dnsmasq format with 7 domains per line:
 - original order: 1.4M file with 9990 lines (longest line: 473 characters)
 - descending order: 1.4M file with 9990 lines (longest line: 520 characters)
 - random order: 1.4M file with 9990 lines (longest line: 238 characters)
dnsmasq format with 8 domains per line:
 - original order: 1.4M file with 8741 lines (longest line: 539 characters)
 - descending order: 1.4M file with 8741 lines (longest line: 621 characters)
 - random order: 1.4M file with 8741 lines (longest line: 267 characters)
dnsmasq format with 9 domains per line:
 - original order: 1.4M file with 7770 lines (longest line: 599 characters)
 - descending order: 1.4M file with 7770 lines (longest line: 659 characters)
 - random order: 1.4M file with 7770 lines (longest line: 287 characters)
dnsmasq format with 10 domains per line:
 - original order: 1.4M file with 6993 lines (longest line: 648 characters)
 - descending order: 1.4M file with 6993 lines (longest line: 729 characters)
 - random order: 1.4M file with 6993 lines (longest line: 311 characters)
```

```sh
$ ./benchmark.sh 'https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/pro.plus.mini-onlydomains.txt' 2>/dev/null
Blocklist: pro.plus.mini-onlydomains-2025.0118.1031.28
domains only: 1.6M file with 83981 lines (longest line: 80 characters)
dnsmasq format with 1 domains per line:
 - original order: 2.2M file with 83981 lines (longest line: 89 characters)
 - descending order: 2.2M file with 83981 lines (longest line: 89 characters)
 - random order: 2.2M file with 83981 lines (longest line: 89 characters)
dnsmasq format with 2 domains per line:
 - original order: 1.9M file with 41991 lines (longest line: 153 characters)
 - descending order: 1.9M file with 41991 lines (longest line: 165 characters)
 - random order: 1.9M file with 41991 lines (longest line: 117 characters)
dnsmasq format with 3 domains per line:
 - original order: 1.8M file with 27994 lines (longest line: 223 characters)
 - descending order: 1.8M file with 27994 lines (longest line: 237 characters)
 - random order: 1.8M file with 27994 lines (longest line: 156 characters)
dnsmasq format with 4 domains per line:
 - original order: 1.7M file with 20996 lines (longest line: 295 characters)
 - descending order: 1.7M file with 20996 lines (longest line: 317 characters)
 - random order: 1.7M file with 20996 lines (longest line: 181 characters)
dnsmasq format with 5 domains per line:
 - original order: 1.7M file with 16797 lines (longest line: 353 characters)
 - descending order: 1.7M file with 16797 lines (longest line: 393 characters)
 - random order: 1.7M file with 16797 lines (longest line: 206 characters)
dnsmasq format with 6 domains per line:
 - original order: 1.7M file with 13997 lines (longest line: 417 characters)
 - descending order: 1.7M file with 13997 lines (longest line: 452 characters)
 - random order: 1.7M file with 13997 lines (longest line: 231 characters)
dnsmasq format with 7 domains per line:
 - original order: 1.7M file with 11998 lines (longest line: 480 characters)
 - descending order: 1.7M file with 11998 lines (longest line: 536 characters)
 - random order: 1.7M file with 11998 lines (longest line: 243 characters)
dnsmasq format with 8 domains per line:
 - original order: 1.6M file with 10498 lines (longest line: 540 characters)
 - descending order: 1.6M file with 10498 lines (longest line: 596 characters)
 - random order: 1.6M file with 10498 lines (longest line: 269 characters)
dnsmasq format with 9 domains per line:
 - original order: 1.6M file with 9332 lines (longest line: 610 characters)
 - descending order: 1.6M file with 9332 lines (longest line: 681 characters)
 - random order: 1.6M file with 9332 lines (longest line: 280 characters)
dnsmasq format with 10 domains per line:
 - original order: 1.6M file with 8399 lines (longest line: 664 characters)
 - descending order: 1.6M file with 8399 lines (longest line: 761 characters)
 - random order: 1.6M file with 8399 lines (longest line: 312 characters)
```

```sh
$ ./benchmark.sh 'https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/tif.txt' 2>/dev/null
Blocklist tif-2025.0118.0820.18
domains only: 15M file with 675783 lines (longest line: 135 characters)
dnsmasq format with 1 domains per line:
 - original order: 20M file with 675783 lines (longest line: 144 characters)
 - descending order: 20M file with 675783 lines (longest line: 144 characters)
 - random order: 20M file with 675783 lines (longest line: 144 characters)
dnsmasq format with 2 domains per line:
 - original order: 17M file with 337892 lines (longest line: 251 characters)
 - descending order: 17M file with 337892 lines (longest line: 251 characters)
 - random order: 17M file with 337892 lines (longest line: 180 characters)
dnsmasq format with 3 domains per line:
 - original order: 16M file with 225261 lines (longest line: 371 characters)
 - descending order: 16M file with 225261 lines (longest line: 387 characters)
 - random order: 16M file with 225261 lines (longest line: 201 characters)
dnsmasq format with 4 domains per line:
 - original order: 16M file with 168946 lines (longest line: 493 characters)
 - descending order: 16M file with 168946 lines (longest line: 492 characters)
 - random order: 16M file with 168946 lines (longest line: 246 characters)
dnsmasq format with 5 domains per line:
 - original order: 16M file with 135157 lines (longest line: 614 characters)
 - descending order: 16M file with 135157 lines (longest line: 613 characters)
 - random order: 16M file with 135157 lines (longest line: 252 characters)
dnsmasq format with 6 domains per line:
 - original order: 15M file with 112631 lines (longest line: 734 characters)
 - descending order: 15M file with 112631 lines (longest line: 734 characters)
 - random order: 15M file with 112631 lines (longest line: 299 characters)
dnsmasq format with 7 domains per line:
 - original order: 15M file with 96541 lines (longest line: 855 characters)
 - descending order: 15M file with 96541 lines (longest line: 855 characters)
 - random order: 15M file with 96541 lines (longest line: 316 characters)
dnsmasq format with 8 domains per line:
 - original order: 15M file with 84473 lines (longest line: 977 characters)
 - descending order: 15M file with 84473 lines (longest line: 976 characters)
 - random order: 15M file with 84473 lines (longest line: 323 characters)
dnsmasq format with 9 domains per line:
 - original order: 15M file with 75087 lines (longest line: 1097 characters)
 - descending order: 15M file with 75087 lines (longest line: 1113 characters)
 - random order: 15M file with 75087 lines (longest line: 364 characters)
dnsmasq format with 10 domains per line:
 - original order: 15M file with 67579 lines (longest line: 1218 characters)
 - descending order: 15M file with 67579 lines (longest line: 1218 characters)
 - random order: 15M file with 67579 lines (longest line: 374 characters)
 ```
