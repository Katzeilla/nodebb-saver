# nodebb-saver
A bash script for save NodeBB content as json file, via native NodeBB API, no server-side plugin required.

## Usage

0. Make sure `jq` and `curl` are installed

1. Clone this repo

2. export Saver_URL & Saver_Cookies

```bash
export Saver_URL='https://example.com'
export Saver_Cookies='express.sid="s:YOURCOOKIES"'
```
3. Go

```bash
./saver.sh MyNodeBB
```

## Todo

- [ ]  Download image
