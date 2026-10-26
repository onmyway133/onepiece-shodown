#!/usr/bin/env python3
"""Synthesizes all sound effects (WAV) and music loops (OGG via ffmpeg).
Run: python3 tools/gen_audio.py
"""
import os
import subprocess
import wave

import numpy as np
from scipy.signal import butter, lfilter, fftconvolve

SR = 44100
ROOT = os.path.join(os.path.dirname(__file__), "..", "assets")
rng = np.random.default_rng(1234)


def t_arr(dur):
    return np.arange(int(SR * dur)) / SR


def env(n, a=0.005, d=None, curve=4.0):
    """Attack then exponential-ish decay over n samples."""
    x = np.linspace(0, 1, n)
    na = max(1, int(a * SR))
    e = np.exp(-curve * x)
    e[:na] *= np.linspace(0, 1, na)
    return e


def filt(x, lo=None, hi=None, order=2):
    if lo and hi:
        b, a = butter(order, [lo / (SR / 2), hi / (SR / 2)], btype="band")
    elif lo:
        b, a = butter(order, lo / (SR / 2), btype="high")
    else:
        b, a = butter(order, hi / (SR / 2), btype="low")
    return lfilter(b, a, x)


def noise(dur):
    return rng.uniform(-1, 1, int(SR * dur))


def sweep_noise(dur, f0, f1, q=0.6):
    """Band-passed noise whose center sweeps from f0 to f1 (block processing)."""
    n = noise(dur)
    out = np.zeros_like(n)
    blocks = 24
    size = len(n) // blocks + 1
    for i in range(blocks):
        s, e = i * size, min(len(n), (i + 1) * size + 400)
        if s >= len(n):
            break
        f = f0 + (f1 - f0) * i / blocks
        seg = filt(n[s:e], max(40, f * (1 - q)), min(SR / 2 - 100, f * (1 + q)))
        w = np.hanning(len(seg))
        out[s:e] += seg * w
    return out


def tone(freqs, dur, decay=4.0, amps=None):
    t = t_arr(dur)
    y = np.zeros_like(t)
    amps = amps or [1.0] * len(freqs)
    for f, a in zip(freqs, amps):
        y += a * np.sin(2 * np.pi * f * t)
    return y * env(len(t), 0.002, curve=decay)


def pitch_drop(f0, f1, dur, decay=5.0):
    t = t_arr(dur)
    f = f1 + (f0 - f1) * np.exp(-t * 25)
    ph = 2 * np.pi * np.cumsum(f) / SR
    return np.sin(ph) * env(len(t), 0.001, curve=decay)


def reverb(x, length=0.8, mix=0.25):
    ir = rng.normal(0, 1, int(SR * length)) * np.exp(-np.linspace(0, 7, int(SR * length)))
    ir = filt(ir, hi=5000)
    wet = fftconvolve(x, ir)[: len(x) + int(SR * length * 0.6)]
    dry = np.concatenate([x, np.zeros(len(wet) - len(x))])
    wet /= max(1e-6, np.max(np.abs(wet)))
    return dry * (1 - mix) + wet * mix * np.max(np.abs(x))


def mix(*parts):
    n = max(len(p) for p in parts)
    out = np.zeros(n)
    for p in parts:
        out[: len(p)] += p
    return out


def norm(x, peak=0.9):
    m = np.max(np.abs(x))
    return x / m * peak if m > 0 else x


def soft(x, drive=1.5):
    return np.tanh(x * drive) / np.tanh(drive)


def write_wav(name, x, peak=0.9):
    x = norm(x, peak)
    fade = min(len(x), 400)
    x[-fade:] *= np.linspace(1, 0, fade)
    d = os.path.join(ROOT, "sfx")
    os.makedirs(d, exist_ok=True)
    with wave.open(os.path.join(d, name + ".wav"), "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes((x * 32767).astype(np.int16).tobytes())


# ---------------------------------------------------------------- effects

def sfx():
    write_wav("swing_l", sweep_noise(0.14, 3200, 1400) * env(int(SR * 0.14), 0.03, curve=3), 0.6)
    write_wav("swing_m", sweep_noise(0.2, 2600, 900) * env(int(SR * 0.2), 0.04, curve=3), 0.7)
    write_wav("swing_h", sweep_noise(0.32, 2000, 500, 0.8) * env(int(SR * 0.32), 0.06, curve=2.5), 0.8)
    t = t_arr(0.3)
    f = 180 + 420 * np.sin(np.clip(t / 0.3, 0, 1) * np.pi * 0.5) + 40 * np.sin(2 * np.pi * 18 * t)
    boing = np.sin(2 * np.pi * np.cumsum(f) / SR) * env(len(t), 0.005, curve=3)
    write_wav("stretch", filt(boing + 0.3 * np.sign(boing) * 0.2, hi=3000), 0.55)

    def hit(dur, f0, f1, crack, body=1.0):
        n = int(SR * dur)
        thump = pitch_drop(f0, f1, dur, 6) * body
        cr = filt(noise(dur), 800, 6000) * env(n, 0.001, curve=30) * crack
        return soft(mix(thump, cr), 2.0)

    write_wav("hit_l", hit(0.14, 260, 120, 0.8), 0.75)
    write_wav("hit_m", hit(0.2, 220, 90, 1.0), 0.85)
    write_wav("hit_h", reverb(hit(0.42, 180, 50, 1.4, 1.3), 0.5, 0.2), 0.95)

    def slash(dur, big):
        n = int(SR * dur)
        sw = filt(noise(dur), 2500, 12000) * env(n, 0.001, curve=14)
        ring = tone([2140, 3410, 5230, 7100], dur, 7.0, [0.5, 0.35, 0.25, 0.15])
        parts = [sw, ring * 0.6]
        if big:
            parts.append(pitch_drop(160, 45, dur, 5) * 1.2)
        return soft(mix(*parts), 1.6)

    write_wav("slash_l", slash(0.3, False), 0.8)
    write_wav("slash_h", reverb(slash(0.6, True), 0.7, 0.25), 0.95)
    write_wav("block", soft(mix(tone([820, 1330, 2120, 3050], 0.25, 12, [0.6, 0.5, 0.35, 0.2]), filt(noise(0.25), 1500, 8000) * env(int(SR * 0.25), 0.001, curve=40))), 0.7)
    write_wav("clash", reverb(tone([1500, 2380, 3900, 5600], 0.7, 5, [0.6, 0.45, 0.3, 0.2]), 0.6, 0.3), 0.8)
    write_wav("jump", sweep_noise(0.18, 600, 2400) * env(int(SR * 0.18), 0.02, curve=3), 0.4)
    write_wav("land", mix(pitch_drop(120, 60, 0.12, 9), filt(noise(0.12), hi=900) * env(int(SR * 0.12), 0.001, curve=20) * 0.6), 0.5)
    write_wav("thud", reverb(mix(pitch_drop(110, 40, 0.4, 6) * 1.2, filt(noise(0.4), hi=700) * env(int(SR * 0.4), 0.001, curve=10)), 0.4, 0.2), 0.85)
    write_wav("dash", mix(sweep_noise(0.22, 1800, 600) * env(int(SR * 0.22), 0.01, curve=4), filt(noise(0.05), hi=1500) * 0.4), 0.55)
    g = np.zeros(int(SR * 0.9))
    for i in range(14):
        s = int(i * SR * 0.055)
        h = hit(0.08, 300 + (i % 3) * 30, 140, 0.6) * (0.7 + 0.3 * (i % 2))
        g[s:s + len(h)] += h[: len(g) - s]
    write_wav("gatling", g, 0.8)
    n = int(SR * 0.9)
    hiss = filt(noise(0.9), 3000, 12000) * np.minimum(1, np.linspace(0, 4, n)) * np.exp(-np.linspace(0, 3, n))
    write_wav("steam", hiss, 0.5)
    n = int(SR * 0.7)
    wind = sweep_noise(0.7, 500, 2800, 0.5) * np.sin(np.linspace(0, np.pi, n)) ** 0.7
    write_wav("wind", wind, 0.7)
    t = t_arr(1.2)
    rumble = filt(noise(1.2), hi=200) * 3 + np.sin(2 * np.pi * (60 + 80 * t) * t) * 0.5
    write_wav("aura", rumble * np.sin(np.linspace(0, np.pi, len(t))) ** 0.5, 0.75)
    t = t_arr(1.1)
    rise = np.sin(2 * np.pi * np.cumsum(200 + 1800 * (t / 1.1) ** 2) / SR) * (t / 1.1) * 0.35
    boom = np.concatenate([np.zeros(int(SR * 0.45)), pitch_drop(120, 35, 0.65, 4) * 1.4])
    flash = np.concatenate([np.zeros(int(SR * 0.45)), filt(noise(0.65), 1000, 9000) * env(int(SR * 0.65), 0.001, curve=8)])
    write_wav("super", reverb(soft(mix(rise, boom, flash), 1.5), 0.8, 0.3), 0.95)
    n = int(SR * 0.9)
    fire = filt(noise(0.9), 300, 4000) * np.exp(-np.linspace(0, 3, n)) * (1 + 0.6 * (rng.random(n) > 0.995))
    growl = np.sin(2 * np.pi * np.cumsum(70 + 20 * np.sin(np.linspace(0, 30, n))) / SR) * np.exp(-np.linspace(0, 2, n)) * 0.6
    write_wav("rage", soft(mix(fire, growl), 1.8), 0.8)
    write_wav("fire", filt(noise(0.5), 400, 5000) * env(int(SR * 0.5), 0.01, curve=4) * (1 + (rng.random(int(SR * 0.5)) > 0.99) * 1.5), 0.7)
    n = int(SR * 1.0)
    write_wav("fire_big", soft(mix(filt(noise(1.0), 150, 3000) * np.exp(-np.linspace(0, 2.5, n)), pitch_drop(90, 40, 1.0, 3) * 0.8), 1.6), 0.9)
    # gong: inharmonic partials with beating
    t = t_arr(2.5)
    partials = [(110, 1.0), (111.5, 0.8), (231, 0.6), (298, 0.5), (412, 0.35), (563, 0.25), (731, 0.2)]
    gong = sum(a * np.sin(2 * np.pi * f * t) * np.exp(-t * (1.0 + f / 400)) for f, a in partials)
    gong += filt(noise(2.5), 200, 3000) * np.exp(-t * 30) * 0.5
    write_wav("gong", gong, 0.85)

    def taiko(dur=0.5, f=95):
        return mix(pitch_drop(f * 1.6, f, dur, 5) * 1.3, filt(noise(dur), hi=1200) * env(int(SR * dur), 0.001, curve=25) * 0.4)

    fight = np.zeros(int(SR * 1.0))
    for s, f in ((0, 95), (0.22, 85)):
        k = taiko(0.6, f)
        i = int(s * SR)
        fight[i:i + len(k)] += k[: len(fight) - i]
    burst = np.concatenate([np.zeros(int(SR * 0.22)), filt(noise(0.5), 600, 8000) * env(int(SR * 0.5), 0.001, curve=6) * 0.5])
    fight[: len(burst)] += burst
    write_wav("fight", reverb(soft(fight, 1.4), 0.7, 0.25), 0.95)
    ko = mix(pitch_drop(90, 30, 1.4, 3) * 1.5, filt(noise(1.4), 200, 6000) * env(int(SR * 1.4), 0.001, curve=6), tone([110, 111.3, 231], 1.4, 2.5, [0.4, 0.3, 0.2]))
    write_wav("ko", reverb(soft(ko, 1.8), 1.2, 0.35), 0.98)
    win = np.zeros(int(SR * 1.4))
    for i, m in enumerate([62, 65, 69, 74, 77]):
        p = pluck(midi(m), 0.9) * (0.8 if i < 4 else 1.0)
        s = int(i * 0.11 * SR)
        win[s:s + len(p)] += p[: len(win) - s]
    write_wav("win", reverb(win, 0.8, 0.3), 0.8)
    write_wav("menu_move", tone([1320, 2640], 0.06, 30, [1, 0.3]), 0.35)
    write_wav("menu_ok", reverb(mix(pluck(midi(74), 0.4), pluck(midi(81), 0.4) * 0.7), 0.4, 0.2), 0.6)
    write_wav("menu_back", tone([660, 990], 0.08, 25, [1, 0.3]), 0.35)
    sfx_elements()


def sfx_elements():
    """Thunder crack and water splash for Nami and Jinbe."""
    n = int(SR * 1.3)
    crack = filt(noise(1.3), 1500, 11000) * env(n, 0.001, curve=40) * 1.4
    roll = filt(noise(1.3), hi=260) * 4.0 * np.exp(-np.linspace(0, 3.5, n)) * (1 + 0.5 * np.sin(np.linspace(0, 40, n)))
    write_wav("thunder", reverb(soft(mix(crack, roll, pitch_drop(90, 30, 1.3, 3)), 1.8), 0.9, 0.3), 0.95)
    n = int(SR * 0.6)
    gush = filt(noise(0.6), 300, 4000) * env(n, 0.01, curve=5)
    bubbles = np.zeros(n)
    for i in range(10):
        s = int(rng.random() * n * 0.7)
        b = tone([float(400 + rng.random() * 900)], 0.06, 30) * 0.4
        bubbles[s:s + len(b)] += b[: n - s]
    write_wav("splash", soft(mix(gush, bubbles, pitch_drop(140, 60, 0.6, 6) * 0.6), 1.5), 0.85)


# ---------------------------------------------------------------- instruments

def midi(m):
    return 440.0 * 2 ** ((m - 69) / 12)


def pluck(f, dur, bright=0.5):
    """Karplus-Strong string, shamisen/koto-like."""
    n = int(SR * dur)
    period = max(2, int(SR / f))
    buf = rng.uniform(-1, 1, period)
    out = np.zeros(n)
    idx = 0
    damp = 0.996 - (1 - bright) * 0.004
    for i in range(n):
        out[i] = buf[idx]
        nxt = (idx + 1) % period
        buf[idx] = damp * 0.5 * (buf[idx] + buf[nxt])
        idx = nxt
    # twangy attack
    out[: int(SR * 0.01)] += filt(noise(0.01), 2000, 9000) * 0.3
    return out


def flute(f, dur, vib=5.5):
    t = t_arr(dur)
    fm = f * (1 + 0.008 * np.sin(2 * np.pi * vib * t) * np.clip(t * 3, 0, 1))
    ph = 2 * np.pi * np.cumsum(fm) / SR
    y = np.sin(ph) + 0.25 * np.sin(2 * ph) + 0.08 * np.sin(3 * ph)
    breath = filt(noise(dur), f, min(SR / 2 - 100, f * 4)) * 0.15
    e = np.minimum(1, t / 0.05) * np.minimum(1, (dur - t) / 0.06).clip(0, 1)
    return (y + breath) * e


def bass(f, dur):
    t = t_arr(dur)
    y = np.sin(2 * np.pi * f * t) + 0.4 * np.sin(4 * np.pi * f * t)
    return soft(y * env(len(t), 0.005, curve=3), 1.3)


def drum_big(dur=0.5):
    return mix(pitch_drop(150, 70, dur, 6) * 1.4, filt(noise(dur), hi=900) * env(int(SR * dur), 0.001, curve=30) * 0.4)


def drum_ka(dur=0.08):
    return filt(noise(dur), 1800, 7000) * env(int(SR * dur), 0.001, curve=40) * 0.6


def song(path, bpm, bars, melody, bass_roots, arp, drums, lead="flute", seed=0, swing=0.0):
    beat = 60.0 / bpm
    eighth = beat / 2
    total = int(SR * bars * 4 * beat) + SR * 2
    out = np.zeros(total)

    def place(x, at, gain=1.0):
        s = int(at * SR)
        e = min(total, s + len(x))
        out[s:e] += x[: e - s] * gain

    # melody: list of bars, each 8 tokens: midi number, '-' hold, '.' rest
    for b, bar in enumerate(melody * (bars // len(melody))):
        toks = bar.split()
        i = 0
        while i < len(toks):
            tok = toks[i]
            if tok in "-.":
                i += 1
                continue
            m = int(tok)
            ln = 1
            while i + ln < len(toks) and toks[i + ln] == "-":
                ln += 1
            at = (b * 8 + i) * eighth
            if lead == "flute":
                place(flute(midi(m), ln * eighth * 0.98), at, 0.32)
            else:
                place(pluck(midi(m), max(0.4, ln * eighth * 1.5)), at, 0.45)
            i += ln
    for b in range(bars):
        root = bass_roots[b % len(bass_roots)]
        for k in range(8):
            if drums == "battle":
                m = root if k % 2 == 0 else root + 12
                place(bass(midi(m - 12), eighth * 0.9), (b * 8 + k) * eighth, 0.28)
            elif k % 4 == 0:
                place(bass(midi(root - 12), beat * 1.8), (b * 8 + k) * eighth, 0.3)
        # plucked arpeggio in 16ths (battle) or 8ths (menu)
        steps = 16 if drums == "battle" else 8
        for k in range(steps):
            iv = arp[k % len(arp)]
            dt = (beat / 4) if steps == 16 else eighth
            place(pluck(midi(root + 12 + iv), 0.35, 0.7), b * 4 * beat + k * dt, 0.16 if steps == 16 else 0.22)
        if drums == "battle":
            for k in range(8):
                at = (b * 8 + k) * eighth
                if k in (0, 3, 4):
                    place(drum_big(), at, 0.55)
                if k in (2, 6):
                    place(drum_ka(), at, 0.5)
                if k % 2 == 1:
                    place(drum_ka(0.04), at, 0.25)
            if b % 4 == 3:
                for k in range(4):
                    place(drum_big(0.3), (b * 8 + 4) * eighth + k * eighth / 2, 0.45)
        else:
            place(drum_big(0.8), b * 4 * beat, 0.25)
            place(drum_ka(), b * 4 * beat + 2 * beat, 0.2)
    loop_len = int(SR * bars * 4 * beat)
    # fold the tail into the start so the loop is seamless
    tail = out[loop_len:]
    out = out[:loop_len]
    out[: len(tail)] += tail
    out = reverb(out, 1.0, 0.18)[:loop_len]
    out = norm(soft(out * 1.2, 1.2), 0.85)
    os.makedirs(os.path.dirname(path), exist_ok=True)
    tmp = path.replace(".ogg", ".wav")
    with wave.open(tmp, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes((out * 32767).astype(np.int16).tobytes())
    subprocess.run(["ffmpeg", "-y", "-loglevel", "error", "-i", tmp, "-c:a", "libvorbis", "-q:a", "4", path], check=True)
    os.remove(tmp)
    print("wrote", path)


def music():
    # D hirajoshi-flavored: D E F A Bb
    battle = [
        "69 - 74 - 76 77 76 74",
        "76 - - - . 69 70 69",
        "65 - 69 - 70 69 65 64",
        "62 - - - - - . .",
        "74 - 77 - 81 - 77 76",
        "77 - 76 74 70 - 69 -",
        "70 69 65 64 65 - 69 -",
        "74 - - - - - . .",
    ]
    song(os.path.join(ROOT, "music", "battle.ogg"), 152, 16, battle, [62, 62, 58, 57, 62, 62, 58, 57], [0, 7, 12, 7, 3, 7, 12, 15], "battle", "flute")
    menu = [
        "74 - - 76 77 - 76 -",
        "74 - 69 - - - . .",
        "70 - 69 - 65 - 64 -",
        "62 - - - - - . .",
    ]
    song(os.path.join(ROOT, "music", "menu.ogg"), 84, 8, menu, [62, 58, 55, 57], [0, 7, 12, 15, 12, 7], "menu", "pluck")


if __name__ == "__main__":
    sfx()
    music()
