#!/Users/masud/Library/ApplicationSupport/iTerm2/iterm2env/versions/3.8.6/bin/python3

import argparse
import asyncio
import sys

import iterm2

def parse_color(value):
    value = int(value)

    r = (value & 0xFF0000) >> 16
    g = (value & 0x00FF00) >>  8
    b = (value & 0x0000FF) >>  0

    return iterm2.Color(r, g, b)

def format_color(color):
    r = int(color.red)
    g = int(color.green)
    b = int(color.blue)

    value  = 0
    value |= r << 16
    value |= g <<  8
    value |= b <<  0

    return str(value)

def parse_args():
    if len(sys.argv) > 1 and sys.argv[1] == 'reset':
        result = argparse.Namespace()
        result.mode = 'reset'
        return result

    parser = argparse.ArgumentParser()
    parser.add_argument("--bg", required=True)
    parser.add_argument("--fg", required=True)
    result = parser.parse_args()
    result.mode = 'set'
    return result

async def set_colors(connection):
    args = parse_args()

    app = await iterm2.async_get_app(connection)

    window = app.current_window
    if window is None:
        return

    tab = window.current_tab
    if tab is None:
        return

    session = tab.current_session
    if session is None:
        return

    profile = await session.async_get_profile()

    async def set_color(storage, kind, new_color):
        current_color = getattr(profile, f"{kind}ground_color")

        setter = getattr(profile, f"async_set_{kind}ground_color")
        storer = lambda c: session.async_set_variable(storage, c)

        await asyncio.gather(
            storer(format_color(current_color)),
            setter(parse_color(new_color)),
        )

    async def reset_color(storage, kind):
        stored_color = await session.async_get_variable(storage)
        if None == stored_color:
            return

        setter = getattr(profile, f"async_set_{kind}ground_color")
        storer = lambda c: session.async_set_variable(storage, c)

        await asyncio.gather(
            storer(None),
            setter(parse_color(stored_color)),
        )

    if args.mode == 'set':
        await asyncio.gather(
            set_color("user.bg", "back", args.bg),
            set_color("user.fg", "fore", args.fg),
        )
    else:
        await asyncio.gather(
            reset_color("user.bg", "back"),
            reset_color("user.fg", "fore"),
        )

def main():
    iterm2.run_until_complete(set_colors)

if __name__ == '__main__':
    main()

