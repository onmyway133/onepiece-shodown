#!/usr/bin/env python3
"""Generates the painted parallax stage layers into assets/stages/<id>/.

Each layer is 2400x1100. Image row 875 is the fighters' ground line.
Run: python3 tools/gen_stages.py
"""
import math
import os
import random

import numpy as np
from PIL import Image, ImageDraw, ImageFilter

W, H = 2400, 1100
GROUND = 875
OUT = os.path.join(os.path.dirname(__file__), "..", "assets", "stages")


def rgba(hexstr, a=255):
    hexstr = hexstr.lstrip("#")
    return tuple(int(hexstr[i:i + 2], 16) for i in (0, 2, 4)) + (a,)


def noise(w, h, scale, octaves=5, seed=0):
    rng = np.random.default_rng(seed)
    out = np.zeros((h, w), np.float32)
    amp, total = 1.0, 0.0
    for o in range(octaves):
        gw = max(2, int(w / scale * 2 ** o))
        gh = max(2, int(h / scale * 2 ** o))
        g = rng.random((gh, gw)).astype(np.float32)
        img = Image.fromarray((g * 255).astype(np.uint8)).resize((w, h), Image.BICUBIC)
        out += np.asarray(img, np.float32) / 255.0 * amp
        total += amp
        amp *= 0.5
    return out / total


def vgrad(stops, h=H, w=W):
    """stops: [(y, (r,g,b)), ...] -> HxWx3 float array."""
    ys = np.arange(h, dtype=np.float32)
    col = np.zeros((h, 3), np.float32)
    for c in range(3):
        col[:, c] = np.interp(ys, [s[0] for s in stops], [s[1][c] for s in stops])
    return np.repeat(col[:, None, :], w, axis=1)


def to_img(arr, alpha=None):
    arr = np.clip(arr, 0, 255).astype(np.uint8)
    if alpha is None:
        alpha = np.full(arr.shape[:2], 255, np.uint8)
    return Image.fromarray(np.dstack([arr, np.clip(alpha, 0, 255).astype(np.uint8)]), "RGBA")


def grain(img, amount=8, seed=1):
    a = np.asarray(img).astype(np.float32)
    rng = np.random.default_rng(seed)
    n = rng.normal(0, amount, a.shape[:2])[:, :, None]
    a[:, :, :3] += n
    return Image.fromarray(np.clip(a, 0, 255).astype(np.uint8), "RGBA")


def glow(img, center, radius, color, strength=1.0):
    layer = Image.new("RGBA", img.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    cx, cy = center
    d.ellipse([cx - radius, cy - radius, cx + radius, cy + radius], fill=color)
    layer = layer.filter(ImageFilter.GaussianBlur(radius * 0.6))
    if strength != 1.0:
        a = np.asarray(layer).astype(np.float32)
        a[:, :, 3] *= strength
        layer = Image.fromarray(np.clip(a, 0, 255).astype(np.uint8), "RGBA")
    return Image.alpha_composite(img, layer)


def clouds(img, y0, y1, tint, shade, seed, density=0.55, scale=420):
    n = noise(W, H, scale, 6, seed)
    band = np.zeros((H, W), np.float32)
    ys = np.arange(H)[:, None]
    mid = (y0 + y1) / 2
    half = (y1 - y0) / 2
    band = np.clip(1.0 - np.abs(ys - mid) / half, 0, 1)
    m = np.clip((n - density) * 4.0, 0, 1) * band
    lit = np.clip((noise(W, H, scale * 0.6, 4, seed + 7) - 0.3) * 1.6, 0, 1)
    col = np.zeros((H, W, 3), np.float32)
    for c in range(3):
        col[:, :, c] = shade[c] * (1 - lit) + tint[c] * lit
    cl = to_img(col, m * 235)
    return Image.alpha_composite(img, cl)


def silhouette(points, color, size=(W, H), blur=0):
    layer = Image.new("RGBA", size, (0, 0, 0, 0))
    ImageDraw.Draw(layer).polygon(points, fill=color)
    if blur:
        layer = layer.filter(ImageFilter.GaussianBlur(blur))
    return layer


def ridge(y_base, amp, seed, step=12, rough=0.5):
    rng = random.Random(seed)
    pts = []
    n = noise(W, 1, 300, 5, seed)[0]
    for x in range(0, W + step, step):
        xi = min(x, W - 1)
        pts.append((x, y_base - amp * n[xi] - rng.random() * amp * 0.05 * rough))
    return pts + [(W, H), (0, H)]


def save(img, stage, name):
    d = os.path.join(OUT, stage)
    os.makedirs(d, exist_ok=True)
    img.save(os.path.join(d, name + ".png"), optimize=True)
    print("wrote", stage, name)


# ---------------------------------------------------------------- Going Merry at sunset

def merry():
    horizon = 640
    sky = vgrad([(0, (46, 24, 78)), (260, (120, 48, 110)), (480, (238, 110, 70)), (600, (255, 196, 110)), (horizon, (255, 222, 150)), (horizon + 1, (60, 70, 120)), (H, (14, 24, 58))])
    img = to_img(sky)
    img = glow(img, (1400, 560), 260, (255, 170, 80, 200))
    img = glow(img, (1400, 585), 70, (255, 245, 210, 255))
    d = ImageDraw.Draw(img)
    d.ellipse([1400 - 62, 585 - 62, 1400 + 62, 585 + 62], fill=(255, 238, 190, 255))
    img = clouds(img, 120, 420, (255, 170, 140), (120, 60, 120), 3, 0.52, 380)
    img = clouds(img, 420, 600, (255, 200, 140), (170, 80, 110), 4, 0.58, 300)
    # sea: reflection streaks
    a = np.asarray(img).astype(np.float32)
    rng = np.random.default_rng(5)
    for i in range(500):
        y = int(horizon + 4 + rng.random() ** 1.6 * (H - horizon - 4))
        spread = 40 + (y - horizon) * 0.9
        x = int(1400 + rng.normal(0, spread))
        ln = int(10 + (y - horizon) * 0.25 * rng.random())
        bright = max(0.0, 1.0 - abs(x - 1400) / (spread * 2.2))
        x0, x1 = max(0, x - ln), min(W, x + ln)
        a[y:y + 2, x0:x1, :3] = a[y:y + 2, x0:x1, :3] * (1 - 0.8 * bright) + np.array([255, 200, 130]) * 0.8 * bright
    wav = noise(W, H, 60, 3, 9)
    a[horizon + 1:, :, :3] *= (0.85 + 0.3 * wav[horizon + 1:])[:, :, None]
    img = grain(Image.fromarray(np.clip(a, 0, 255).astype(np.uint8), "RGBA"), 5)
    save(img, "merry", "sky")

    # far: islands
    far = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    isl = [(300, 520, 640), (900, 240, 610), (2000, 380, 630)]
    for x, w, top in isl:
        pts = [(x - w // 2, horizon + 2)]
        n = noise(w, 1, 80, 4, x)[0]
        for i in range(0, w, 8):
            pts.append((x - w // 2 + i, top + (1 - math.sin(i / w * math.pi)) * (horizon - top) + n[i] * 20))
        pts.append((x + w // 2, horizon + 2))
        far = Image.alpha_composite(far, silhouette(pts, (90, 50, 90, 230), blur=1))
    # distant marine ship
    s = silhouette([(1750, horizon), (1830, horizon), (1815, horizon + 8), (1765, horizon + 8)], (60, 40, 70, 220))
    far = Image.alpha_composite(far, s)
    ImageDraw.Draw(far).line([(1790, horizon), (1790, horizon - 40)], fill=(60, 40, 70, 220), width=3)
    ImageDraw.Draw(far).polygon([(1792, horizon - 38), (1812, horizon - 20), (1792, horizon - 10)], fill=(220, 200, 210, 200))
    save(far, "merry", "far")

    # mid: mast, sail with the straw hat jolly roger, rigging
    mid = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(mid)
    wood = (96, 58, 34, 255)
    dark = (40, 22, 14, 255)
    for mx in (700, 1750):
        d.rectangle([mx - 22, 0, mx + 22, 860], fill=wood, outline=dark, width=4)
        d.rectangle([mx - 6, 0, mx + 2, 860], fill=(130, 84, 50, 255))
        d.rectangle([mx - 200, 120, mx + 200, 140], fill=wood, outline=dark, width=3)
    # sail on main mast
    sx = 1750
    sail = [(sx - 190, 140), (sx + 190, 140), (sx + 215, 520), (sx - 215, 520)]
    d.polygon(sail, fill=(246, 240, 226, 255), outline=dark)
    for i in range(1, 6):
        d.line([(sx - 190 + i * 63, 140), (sx - 215 + i * 72, 520)], fill=(220, 210, 195, 255), width=2)
    # jolly roger: skull with straw hat and crossbones
    cx, cy = sx, 330
    d.line([(cx - 110, cy + 90), (cx + 110, cy - 20)], fill=(30, 26, 30, 255), width=26)
    d.line([(cx - 110, cy - 20), (cx + 110, cy + 90)], fill=(30, 26, 30, 255), width=26)
    d.ellipse([cx - 80, cy - 70, cx + 80, cy + 80], fill=(30, 26, 30, 255))
    d.rectangle([cx - 45, cy + 50, cx + 45, cy + 110], fill=(30, 26, 30, 255))
    d.ellipse([cx - 50, cy - 10, cx - 12, cy + 34], fill=(246, 240, 226, 255))
    d.ellipse([cx + 12, cy - 10, cx + 50, cy + 34], fill=(246, 240, 226, 255))
    d.polygon([(cx, cy + 40), (cx - 10, cy + 60), (cx + 10, cy + 60)], fill=(246, 240, 226, 255))
    d.ellipse([cx - 150, cy - 80, cx + 150, cy - 40], fill=(242, 200, 80, 255), outline=dark, width=3)
    d.chord([cx - 82, cy - 150, cx + 82, cy - 10], 180, 360, fill=(242, 200, 80, 255), outline=dark, width=3)
    d.rectangle([cx - 82, cy - 86, cx + 82, cy - 64], fill=(190, 35, 40, 255))
    # rigging ropes
    for mx in (700, 1750):
        for k in range(-3, 4):
            d.line([(mx, 40), (mx + k * 140, 760)], fill=(70, 50, 40, 200), width=3)
    # back rail of the deck
    d.rectangle([0, 700, W, 718], fill=wood, outline=dark, width=3)
    for x in range(10, W, 46):
        d.rectangle([x, 718, x + 14, 790], fill=(120, 76, 44, 255), outline=dark, width=2)
    d.rectangle([0, 785, W, 800], fill=wood, outline=dark, width=3)
    mid = mid.filter(ImageFilter.GaussianBlur(0.8))
    save(grain(mid, 4), "merry", "mid")

    # ground: deck planks
    g = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(g)
    top = 795
    d.rectangle([0, top, W, H], fill=(140, 92, 54, 255))
    a = np.asarray(g).astype(np.float32)
    n = noise(W, H, 40, 4, 12)
    streak = noise(W, H, 6, 2, 13)
    ys = np.arange(H)
    plank_h = 26
    for y0 in range(top, H, plank_h):
        k = (y0 - top) / (H - top)
        tone = 0.85 + 0.25 * ((y0 // plank_h) % 3) / 2
        a[y0:y0 + plank_h, :, :3] *= tone
        a[y0:y0 + 3, :, :3] *= 0.45
    a[top:, :, :3] *= (0.85 + 0.25 * n[top:])[:, :, None]
    a[top:, :, :3] *= (0.95 + 0.1 * streak[top:])[:, :, None]
    # light from the sunset
    light = np.clip(1.0 - np.abs(np.arange(W) - 1400) / 1400.0, 0, 1)
    a[top:, :, 0] += 30 * light
    a[top:, :, 1] += 14 * light
    # shading near the back
    fade = np.clip((ys - top) / 80.0, 0, 1)
    a[:, :, :3] *= (0.6 + 0.4 * fade)[:, None, None]
    g = Image.fromarray(np.clip(a, 0, 255).astype(np.uint8), "RGBA")
    d = ImageDraw.Draw(g)
    rng = random.Random(4)
    for y0 in range(top, H, plank_h):
        x = rng.randint(0, 300)
        while x < W:
            d.line([(x, y0 + 3), (x, y0 + plank_h)], fill=(70, 42, 24, 255), width=2)
            d.ellipse([x + 8, y0 + 10, x + 12, y0 + 14], fill=(60, 40, 30, 255))
            x += rng.randint(260, 420)
    save(grain(g, 5), "merry", "ground")


# ---------------------------------------------------------------- Wano sakura shrine

def sakura_tree(d, x, base, h, rng, trunk=(70, 40, 40, 255), blossom=None, scale=1.0):
    d.polygon([(x - 18 * scale, base), (x + 18 * scale, base), (x + 8 * scale, base - h * 0.6), (x - 6 * scale, base - h * 0.6)], fill=trunk)
    for k in range(3):
        bx = x + rng.randint(-140, 140) * scale
        d.line([(x, base - h * 0.5), (bx, base - h * (0.75 + 0.1 * k))], fill=trunk, width=int(10 * scale))
    for i in range(70):
        cx = x + rng.gauss(0, 150 * scale)
        cy = base - h * 0.8 + rng.gauss(0, 70 * scale)
        r = rng.randint(28, 60) * scale
        c = blossom or (255, 170 + rng.randint(0, 40), 200 + rng.randint(0, 30), 235)
        d.ellipse([cx - r, cy - r * 0.8, cx + r, cy + r * 0.8], fill=c)


def wano():
    horizon = 700
    sky = vgrad([(0, (40, 30, 80)), (300, (130, 70, 140)), (560, (250, 150, 150)), (horizon, (255, 205, 170)), (H, (255, 205, 170))])
    img = to_img(sky)
    img = glow(img, (800, 420), 300, (255, 220, 190, 140))
    d = ImageDraw.Draw(img)
    d.ellipse([800 - 90, 420 - 90, 800 + 90, 420 + 90], fill=(255, 244, 225, 255))
    img = clouds(img, 150, 450, (255, 200, 210), (140, 90, 150), 21, 0.55, 350)
    # mountain with snow cap
    m = [(1100, 690), (1500, 240), (1560, 230), (1980, 690)]
    img = Image.alpha_composite(img, silhouette(m, (120, 90, 150, 255)))
    cap = [(1415, 340), (1500, 240), (1560, 230), (1650, 345), (1600, 330), (1560, 360), (1520, 330), (1470, 360)]
    img = Image.alpha_composite(img, silhouette(cap, (250, 240, 250, 255)))
    img = Image.alpha_composite(img, to_img(np.zeros((H, W, 3)) + np.array([255, 210, 200]), np.clip((np.arange(H)[:, None] - 520) / 200.0, 0, 1) * np.ones((1, W)) * 120))
    save(grain(img, 4), "wano", "sky")

    far = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    far = Image.alpha_composite(far, silhouette(ridge(720, 150, 31), (150, 100, 150, 255), blur=2))
    d = ImageDraw.Draw(far)
    # pagoda silhouette
    px, py = 560, 690
    col = (90, 50, 90, 255)
    for i in range(5):
        w = 150 - i * 22
        y = py - i * 70
        d.polygon([(px - w, y), (px + w, y), (px + w * 0.6, y - 26), (px - w * 0.6, y - 26)], fill=col)
        d.rectangle([px - w * 0.45, y - 70, px + w * 0.45, y - 26], fill=col)
    d.line([(px, py - 350), (px, py - 430)], fill=col, width=6)
    rng = random.Random(7)
    for x in range(80, W, 220):
        sakura_tree(d, x + rng.randint(-40, 40), 760, 160, rng, trunk=(110, 60, 90, 255), blossom=(235, 150, 190, 200), scale=0.6)
    save(far.filter(ImageFilter.GaussianBlur(1.5)), "wano", "far")

    mid = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(mid)
    rng = random.Random(11)
    # big torii gate
    red = (200, 40, 40, 255)
    dark = (60, 14, 18, 255)
    tx = 1200
    d.rectangle([tx - 330, 230, tx - 280, 800], fill=red, outline=dark, width=4)
    d.rectangle([tx + 280, 230, tx + 330, 800], fill=red, outline=dark, width=4)
    d.polygon([(tx - 460, 200), (tx + 460, 200), (tx + 420, 240), (tx - 420, 240)], fill=(40, 30, 34, 255))
    d.rectangle([tx - 430, 240, tx + 430, 270], fill=red, outline=dark, width=4)
    d.rectangle([tx - 380, 330, tx + 380, 360], fill=red, outline=dark, width=4)
    d.rectangle([tx - 30, 270, tx + 30, 330], fill=(40, 30, 34, 255))
    # stone lanterns
    for lx in (450, 1950):
        stone = (150, 140, 150, 255)
        d.rectangle([lx - 50, 780, lx + 50, 800], fill=stone, outline=(70, 60, 70, 255), width=3)
        d.rectangle([lx - 14, 640, lx + 14, 780], fill=stone, outline=(70, 60, 70, 255), width=3)
        d.rectangle([lx - 40, 590, lx + 40, 640], fill=stone, outline=(70, 60, 70, 255), width=3)
        d.rectangle([lx - 22, 600, lx + 22, 630], fill=(255, 210, 120, 255))
        d.polygon([(lx - 70, 590), (lx + 70, 590), (lx + 20, 540), (lx - 20, 540)], fill=stone, outline=(70, 60, 70, 255))
    for x in (120, 760, 1680, 2280):
        sakura_tree(d, x, 810, 420, rng)
    mid = mid.filter(ImageFilter.GaussianBlur(0.7))
    for lx in (450, 1950):
        mid = glow(mid, (lx, 615), 60, (255, 200, 120, 160))
    save(grain(mid, 4), "wano", "mid")

    g = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    a = np.zeros((H, W, 4), np.float32)
    top = 800
    n = noise(W, H, 30, 5, 41)
    a[top:, :, 0] = 150 + 50 * n[top:]
    a[top:, :, 1] = 120 + 40 * n[top:]
    a[top:, :, 2] = 120 + 40 * n[top:]
    a[top:, :, 3] = 255
    ys = np.arange(H)
    fade = np.clip((ys - top) / 70.0, 0, 1)
    a[:, :, :3] *= (0.6 + 0.4 * fade)[:, None, None]
    g = Image.fromarray(np.clip(a, 0, 255).astype(np.uint8), "RGBA")
    d = ImageDraw.Draw(g)
    # stone tiles of the shrine path
    rng = random.Random(3)
    for y0 in range(top + 20, H, 70):
        off = rng.randint(0, 150)
        for x in range(-off, W, 180):
            d.rectangle([x + 4, y0, x + 176, y0 + 64], outline=(110, 90, 100, 255), width=3)
    for i in range(500):
        x, y = rng.randint(0, W), rng.randint(top + 5, H)
        d.ellipse([x, y, x + 7, y + 4], fill=(255, 180, 200, 230))
    save(grain(g, 5), "wano", "ground")


# ---------------------------------------------------------------- Alabasta desert night

def alabasta():
    horizon = 690
    sky = vgrad([(0, (8, 10, 34)), (400, (28, 36, 84)), (horizon, (90, 80, 120)), (H, (90, 80, 120))])
    img = to_img(sky)
    a = np.asarray(img).astype(np.float32)
    rng = np.random.default_rng(8)
    for i in range(1500):
        x, y = rng.integers(0, W), rng.integers(0, 600)
        b = rng.random() ** 3
        a[y, x, :3] = a[y, x, :3] * (1 - b) + 255 * b
    img = Image.fromarray(np.clip(a, 0, 255).astype(np.uint8), "RGBA")
    img = glow(img, (600, 300), 260, (190, 200, 255, 120))
    d = ImageDraw.Draw(img)
    d.ellipse([600 - 120, 300 - 120, 600 + 120, 300 + 120], fill=(245, 240, 220, 255))
    d.ellipse([560, 260, 600, 300], fill=(225, 220, 200, 255))
    d.ellipse([630, 340, 660, 365], fill=(228, 222, 204, 255))
    img = clouds(img, 380, 560, (150, 140, 190), (40, 40, 80), 51, 0.6, 400)
    save(grain(img, 4), "alabasta", "sky")

    far = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    far = Image.alpha_composite(far, silhouette(ridge(740, 120, 61), (70, 52, 70, 255), blur=1))
    d = ImageDraw.Draw(far)
    # palace silhouette with domes
    c = (50, 38, 56, 255)
    px = 1600
    d.rectangle([px - 300, 520, px + 300, 720], fill=c)
    for dx, r in ((-200, 50), (0, 90), (200, 50)):
        d.ellipse([px + dx - r, 520 - r * 1.4, px + dx + r, 520 + r * 0.4], fill=c)
        d.line([(px + dx, 520 - r * 1.4), (px + dx, 520 - r * 1.4 - 40)], fill=c, width=4)
    for dx in (-330, 330):
        d.rectangle([px + dx - 22, 380, px + dx + 22, 720], fill=c)
        d.ellipse([px + dx - 30, 350, px + dx + 30, 400], fill=c)
    for i in range(40):
        x = px - 280 + i * 14
        if i % 3 == 0:
            d.rectangle([x, 600, x + 6, 612], fill=(255, 200, 120, 255))
    save(far, "alabasta", "far")

    mid = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(mid)
    sand = (196, 150, 100, 255)
    sdark = (90, 60, 50, 255)
    # ruined pillars
    for x, h in ((300, 420), (420, 260), (1900, 380), (2050, 300)):
        d.rectangle([x - 40, 800 - h, x + 40, 800], fill=sand, outline=sdark, width=4)
        for k in range(3):
            d.line([(x - 20 + k * 20, 800 - h + 10), (x - 20 + k * 20, 795)], fill=(160, 120, 80, 255), width=3)
        d.rectangle([x - 55, 800 - h - 20, x + 55, 800 - h], fill=sand, outline=sdark, width=4)
    # palm trees
    rng = random.Random(9)
    for x in (900, 1250):
        pts = []
        for i in range(30):
            t = i / 29
            pts.append((x + math.sin(t * 2.2) * 60 * t, 805 - t * 420))
        for i in range(len(pts) - 1):
            d.line([pts[i], pts[i + 1]], fill=(80, 56, 44, 255), width=int(26 - i * 0.4))
        tx, ty = pts[-1]
        for k in range(8):
            ang = -math.pi / 2 + (k - 3.5) * 0.45
            for j in range(18):
                t = j / 17
                lx = tx + math.cos(ang) * 200 * t
                ly = ty + math.sin(ang) * 200 * t + 120 * t * t
                d.ellipse([lx - 14 * (1 - t) - 3, ly - 6, lx + 14 * (1 - t) + 3, ly + 6], fill=(40, 80, 60, 255))
    mid = mid.filter(ImageFilter.GaussianBlur(0.6))
    # moonlight tint
    a = np.asarray(mid).astype(np.float32)
    a[:, :, 0] *= 0.7
    a[:, :, 1] *= 0.75
    a[:, :, 2] *= 0.95
    save(grain(Image.fromarray(np.clip(a, 0, 255).astype(np.uint8), "RGBA"), 4), "alabasta", "mid")

    top = 790
    a = np.zeros((H, W, 4), np.float32)
    n = noise(W, H, 50, 5, 71)
    ys = np.arange(H)[:, None]
    xs = np.arange(W)[None, :]
    ripple = 0.5 + 0.5 * np.sin(xs * 0.03 + ys * 0.35 + n * 6.0)
    a[:, :, 0] = 170 + 40 * n + 14 * ripple
    a[:, :, 1] = 130 + 30 * n + 10 * ripple
    a[:, :, 2] = 110 + 26 * n + 10 * ripple
    a[:, :, 3] = 255
    a[:top] = 0
    fade = np.clip((np.arange(H) - top) / 70.0, 0, 1)
    a[:, :, :3] *= (0.55 + 0.45 * fade)[:, None, None]
    a[:, :, 0] *= 0.82
    a[:, :, 2] *= 1.05
    save(grain(Image.fromarray(np.clip(a, 0, 255).astype(np.uint8), "RGBA"), 5), "alabasta", "ground")


def title_bg():
    sky = vgrad([(0, (20, 10, 30)), (400, (120, 30, 40)), (720, (240, 120, 60))], h=720, w=1280)
    img = to_img(sky)
    img = glow(img, (900, 470), 240, (255, 190, 100, 200))
    d = ImageDraw.Draw(img)
    d.ellipse([900 - 160, 470 - 160, 900 + 160, 470 + 160], fill=(255, 230, 180, 255))
    n = noise(1280, 720, 300, 5, 91)
    a = np.asarray(img).astype(np.float32)
    m = np.clip((n - 0.5) * 3, 0, 1) * np.clip(1 - np.abs(np.arange(720)[:, None] - 300) / 300, 0, 1)
    a[:, :, :3] = a[:, :, :3] * (1 - m[:, :, None] * 0.6) + np.array([60, 15, 30]) * m[:, :, None] * 0.6
    img = Image.fromarray(np.clip(a, 0, 255).astype(np.uint8), "RGBA")
    sea = silhouette([(0, 600), (1280, 600), (1280, 720), (0, 720)], (20, 10, 26, 255), size=(1280, 720))
    img = Image.alpha_composite(img, sea)
    os.makedirs(os.path.join(OUT, "..", "ui"), exist_ok=True)
    grain(img, 5).save(os.path.join(OUT, "..", "ui", "title_bg.png"), optimize=True)
    print("wrote title bg")


if __name__ == "__main__":
    merry()
    wano()
    alabasta()
    title_bg()
