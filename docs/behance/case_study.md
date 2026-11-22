# KoeNaWin Dhamma — Behance case study (draft v1)

> Draft text for review. Each `##` section becomes one or more 1400px-wide images in Figma.
> Lines starting with `[Visual]` describe what goes on that image. They are not published text.

---

## 01 · Cover

**KoeNaWin Dhamma**
A calm daily companion for the 81-day KoeNaWin practice.

UX/UI Design · Android app · 2026

[Visual] App icon, three phone mockups (Today card, Gatha reader, Video player) on the yogi-brown background with the gold Dhamma wheel.

---

## 02 · Overview

**The project**
KoeNaWin is a Buddhist practice followed by many people in Myanmar: 81 days of reciting the nine attributes of the Buddha, in a fixed order, without missing a day. I designed and built an Android app that tells practitioners exactly what to recite today, reminds them every morning, and keeps the chants and dhamma talks they use in one place.

| | |
|---|---|
| Role | UX research, UX/UI design, design system, Android build (AI-assisted development) |
| Platform | Android (Flutter) |
| Tools | Figma, Flutter, Claude Code, Phosphor Icons |
| Timeline | 2026 |
| Language | Myanmar UI |

---

## 03 · What is KoeNaWin?

For readers outside Myanmar, the practice has strict rules, and every one of them shapes the design:

- **9 stages × 9 days = 81 days**, in order.
- Each day has one of the **nine attributes of the Buddha** and a set **number of rounds** on the prayer beads.
- One day in each stage is a **vegetarian day**.
- Everyone starts on a **Monday**, whatever day they were born.
- **Missing a day** means starting again from the beginning.

[Visual] A 9×9 grid diagram: stages as rows, days as columns, vegetarian days marked in gold, an arrow showing "start on Monday".

---

## 04 · The problem

Practitioners keep track on paper, from a printed chart, or in their heads. Over 81 days that goes wrong in predictable ways:

- **"Which day am I on?"** It's easy to lose track of the day and stage, especially after a busy week.
- **Reciting the wrong attribute** or the wrong number of rounds for the day.
- **Forgetting a day**, then not knowing whether the practice is broken.
- **Coming back after a pause**: there's no clear way to resume at the right point.
- Chants and dhamma talks are scattered across books, YouTube and other apps.

---

## 05 · Competitive analysis

I reviewed the KoeNaWin apps on Google Play, using their store listings and public user reviews (checked November 2026). I also use the first one myself.

| | Koe Na Win · Nyi Lin | ကိုးနဝင်းအဓိဋ္ဌာန် · Kyaw Thiha | Koe Na Win · Aero IT |
|---|---|---|---|
| Downloads | 100K+ | 100K+ | 10K+ |
| Rating | 5.0 (528 reviews) | 4.8 (560 reviews) | 4.6 (225 reviews) |
| Last update | Jul 2025 | Aug 2025 | Oct 2019 |
| Ads | Yes | No | Yes |

**Koe Na Win (Nyi Lin)**
- ✅ Built-in bead counter that remembers the count after switching apps; dark mode.
- ⚠️ Users report the history showing "missed" after choosing to continue, and progress that never completes.
- ⚠️ A reviewer asked for bigger tap targets and smaller ads.
- 🧘 *From my own use:* the app lets you keep going after missing a day. The practice requires starting again, so the app quietly allows a broken practice to look complete.

**ကိုးနဝင်းအဓိဋ္ဌာန် (Kyaw Thiha)**
- ✅ Simple, no ads, collects no data. Reviewers call it "very useful for beginners" and use it every day.
- ⚠️ Users ask for an alarm or reminder. One review reports incorrect data.

**Koe Na Win (Aero IT)**
- ✅ Praised for clearing up confusion about "the current day or stage".
- ⚠️ Ads appear while users are counting beads. A reviewer said they'd pay to remove them.
- ⚠️ The notification is unreadable (white text on a white background). No update since 2019.

**What the reviews tell me**

| Insight from reviews | Opportunity |
|---|---|
| People most want to know *today's* day and stage | Make "today" the first thing on screen |
| Reminders are requested but missing | A daily morning reminder that names today's attribute |
| Resume and missed-day logic confuses users, or isn't enforced at all | Enforce the rules and explain them at the moment they apply |
| Ads interrupt a meditative moment | No ads, a calm visual language |
| Readability and tap-target problems | Large type, adjustable text size, 48dp targets |
| Practice content lives elsewhere | Chants and dhamma talks inside the same app |

[Visual] The comparison table, then the insight → opportunity table as cards.

---

## 06 · Who it's for

*These are assumptions from the practice itself and from the store reviews. I didn't run user interviews for this project.*

- Buddhist practitioners in Myanmar, many of them middle-aged or older.
- Comfortable with Myanmar script, less comfortable with English.
- Use the app at a fixed time each day, often with prayer beads in hand.
- Low tolerance for clutter: they want the answer and then to get on with the practice.

---

## 07 · Design principles

1. **Today first.** Open the app and see what to recite today, with no searching.
2. **The app keeps the rules.** Monday starts, missed days and resuming are handled by the app, not remembered by the user.
3. **Calm, not busy.** Warm yogi-brown and antique gold, no ads, gentle motion.
4. **Easy to read.** The Pyidaungsu font, generous line height, adjustable text size.

---

## 08 · Structure & flows

**Three tabs:** KoeNaWin · Dhamma (chants) · Video

[Visual] Information architecture diagram of the three tabs.

**Starting the practice**
Open app → not on Monday? → "You can start on Monday" → on Monday: new or continuing? → new: start Day 1 → continuing: pick stage and day → Today card

**A missed day**
Open app → a day was missed → warning that names the missed day → progress resets → start page

[Visual] Two flow diagrams.

---

## 09 · Key UX decisions

**1 · The Today card**
*Problem:* users lose track of the day and stage.
*Decision:* the KoeNaWin tab opens on a card with today's stage and day, the attribute, its meaning and the number of rounds. Marking the day done is one tap.
[Visual] Today card screen with callouts.

**2 · Monday-only start**
*Problem:* starting on the wrong day breaks the practice before it begins.
*Decision:* on any other day, a sheet explains the rule and shows when the user can start.

**3 · Resuming at the right point**
*Problem:* people who began on paper, or paused, need to join at the right day.
*Decision:* the user picks a stage and day, but only days that fall on today's weekday can be chosen, so the schedule stays correct.
[Visual] Resume picker sheet.

**4 · Missed days, explained**
*Problem:* in the app I used myself, you can simply carry on after missing a day, which goes against the practice. Another app shows a confusing "missed" state.
*Decision:* the app follows the rule. A clear message names the day that was missed and explains that the practice starts again, then the app returns to the start page. It's honest with the user instead of letting a broken practice look complete.

**5 · A reminder that teaches**
*Problem:* reminders are the most requested missing feature.
*Decision:* a notification every morning at 6 AM that names today's attribute, so the user knows what to recite before opening the app.

**6 · A readable chant reader**
*Problem:* long Pali verses are hard to read on a small screen, and line breaks fall in the middle of words.
*Decision:* each verse line (pada) gets its own line, text size can be adjusted, and previous/next buttons move between chants.
[Visual] Gatha screen at default and enlarged text size.

**7 · Dhamma talks that keep playing**
*Problem:* morning and evening talks are long and come in sets.
*Decision:* tap any talk and the rest of the session plays in order. The screen stays awake. If YouTube blocks playback, the app explains the likely cause (a VPN) and offers a retry.
[Visual] Video player with the queue states: playing, done, up next.

---

## 10 · Design system

- **Color:** Material 3 roles. Yogi brown primary, antique gold accent, warm cream surfaces. Light mode only, for a calm and consistent look.
- **Type:** Pyidaungsu Regular and Bold, mapped to the Material type scale.
- **Icons:** Phosphor Icons, Regular for default and Fill for selected.
- **Components:** stage card, today card, bottom sheets, gatha reader controls, video card, queue tile.
- **Motion:** staggered fade-up lists, splash wheel animation.

[Visual] Color swatches, type scale, icon grid, component sheet (from the Figma 01-foundations and 02-components pages).

---

## 10b · Figma to Real World

**From Figma to a real app**
I built the design in Flutter with AI-assisted development. Because the Figma file had strict naming from day one, every style, icon and frame maps one-to-one to the code.

| | Figma | Flutter |
|---|---|---|
| Color | `primary/Primary` | `ColorScheme.primary` |
| Typography | `Title/Large` | `textTheme.titleLarge` |
| Icon | `ic_caret_left` · Regular | `PhosphorIconsRegular.caretLeft` |
| Component | Step Card | `StageCard()` |
| Frame | `Dhamma / AllDhamma` | `dhamma/screens/all_dhamma_screen.dart` |

**The rules live in code, not in the user's memory** (simplified snippets from `koenawin_controller.dart`)

```dart
// A day passed without being marked done:
// the practice starts again.
if (todayNumber > lastCompletedDay + 1) {
  missedDay = lastCompletedDay + 1;
  await _reset();
}
```

```dart
// Days the user may resume on: only
// those that fall on today's weekday.
bool canResumeOn(KoeNaWinDay day) =>
    day.weekday == today.weekday;
```

- 11 automated tests cover the practice rules.
- Flutter 3.38 · Material 3 · provider · local notifications
- Signed Android APK, version 1.0.0

**Links**
- Source code: https://github.com/sawtheinwintun/koenawin-dhamma
- Download for Android (APK): https://www.dropbox.com/scl/fi/9nudyfkn5i8g5rvysakpk/KoeNaWin-1.0.0.apk?rlkey=wpoxpry837393swt73teds6mp&dl=0

[Visual] Screen recording of the app (uploaded to Behance as a video module).

---

## 11 · Final screens

[Visual] Splash · KoeNaWin stages · Stage detail · Today card · Completion · Dhamma list · Gatha reader · Video list · Video player

---

## 12 · Outcome & next steps

**Outcome**
- A working Android app, shared as a signed APK with family and friends.
- Every rule of the practice (Monday start, missed days, resume, vegetarian days, completion) is handled by the app.

**What I learned**
- In a ritual app, the real UX work is turning rules into clear moments: telling users the right thing at the right time.
- Store reviews of existing apps are an honest, low-cost source of user needs when interviews aren't possible.
- AI-assisted development let me take the design all the way to a working app, so I could test UX decisions on a real device instead of only in prototypes.

**Next steps**
- Collect feedback from real practitioners and test with older users.
- Consider an optional on-screen bead counter, which the most popular competitor offers.
- Let users choose the reminder time.

---

*Thank you for viewing.*
