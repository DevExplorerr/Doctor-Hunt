<p align="center">
  <img src="assets/app_logo.png" alt="Doctor Hunt logo" width="110">
</p>

<h1 align="center">Doctor Hunt</h1>

<p align="center">
  A Flutter-based doctor discovery and appointment-booking application<br>
  with AI-powered medical document analysis and a multilingual AI symptom checker.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-Mobile_App-02569B?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/GetX-State_Management-8A2BE2" alt="GetX">
  <img src="https://img.shields.io/badge/Firebase-Auth_+_Firestore-FFCA28?logo=firebase" alt="Firebase">
  <img src="https://img.shields.io/badge/Node.js-AI_Backend-339933?logo=node.js" alt="Node.js">
  <img src="https://img.shields.io/badge/Qwen-AI_(Alibaba_Model_Studio)-6C4AB6" alt="Qwen AI">
</p>

---

Doctor Hunt is split into two repositories:

| Repository                                                                    | Description                                                         |
| ----------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| [DevExplorerr/Doctor-Hunt](https://github.com/DevExplorerr/Doctor-Hunt)       | **This repository** — the Flutter mobile application                |
| [DevExplorerr/Doctor-Hunt-AI](https://github.com/DevExplorerr/Doctor-Hunt-AI) | The Node.js/Express AI backend (symptom triage + document decoding) |

## Overview

Doctor Hunt lets patients find the right doctor and book appointments in a few taps, and helps them make sense of their own medical documents.

- **What it does** — Patients browse or search doctors across 10 specialties, view detailed doctor profiles, pick a free time slot on a 7-day calendar, and confirm a booking with patient details. Bookings are protected against double-booking by Firestore transactions.
- **The problem it solves** — It replaces phone-call scheduling with a self-service mobile flow, and replaces "unreadable prescription / lab report" confusion with an AI-generated plain-language breakdown (summary, medications, lab findings, warnings).
- **Main user workflow** — Sign up / log in → discover doctors (categories, popular/featured lists, search, AI symptom checker) → doctor details → select time → patient details → confirmed appointment (visible under _My Appointments_, cancelable and reschedulable). In parallel, users can decode prescriptions/lab reports with the AI Document Decoder, keep a personal medical-records folder, and order medicines from the in-app pharmacy.
- **How the pieces fit together** — The AI Symptom Checker ends its triage by recommending one of the 10 app specialties and jumps straight to the matching doctor list. The Document Decoder analyzes uploaded prescriptions/lab reports and its results can be copied, exported as a PDF report, or saved to Medical Records. All AI calls go through the separate Doctor Hunt AI backend, so no AI credentials ever ship inside the app.

## Features

### Doctors & appointments

- **Doctor discovery** — home screen with specialty categories, popular doctors, featured doctors, and upcoming-appointment cards
- **Doctor search** — live search by doctor name or specialty, with a clear/reset action
- **Specialty filtering** — filter the doctor list by any of the 10 supported specialties
- **Doctor details** — rating, reviews, experience, consultation fee, services, and patient statistics
- **Favorites** — save and remove favorite doctors
- **Recurring doctor time slots** — each doctor has a recurring (weekday-based) master schedule; the Select Time screen applies weekday availability rules and hides past slots for today
- **Booked-slot handling** — already-booked slots are disabled in the slot grid; available-slot counts per day are computed without extra Firestore reads
- **Double-booking protection** — the final booking runs inside a Firestore transaction with deterministic slot-reservation documents (see [Booking Architecture](#booking-architecture))
- **Appointment cancellation** — transactional: marks the appointment `canceled` and frees the slot reservation atomically
- **Appointment rescheduling** — transactional: releases the old slot, reserves the new one, and updates the appointment in one transaction
- **My Appointments** — appointments grouped into upcoming, completed, and canceled

### AI features (via Doctor Hunt AI backend)

- **AI Symptom Checker** — conversational triage that asks follow-up questions (with tappable answer chips), assesses urgency, shows an emergency warning when needed, recommends a specialty, and links directly to the matching doctors; supports **English and Urdu** conversations
- **AI Medical Document Decoder** — analyze prescriptions, lab reports, and other medical documents from camera, gallery, or PDF; returns a structured breakdown: document type, summary, medications (dosage/frequency/duration/instructions), lab findings (value, reference range, interpretation), key findings, warnings, confidence, and a medical disclaimer
- **Copy analyzed results** — copy the full analysis text to the clipboard
- **Download analyzed results** — export the analysis as a formatted PDF report (via the system share sheet)

### Voice

- **Voice input for the Symptom Checker** — on-device speech-to-text with a live transcript preview and a recording timer; continuous segmented listening with automatic restart
- **English speech** (en-US) by default, with device Urdu-locale detection and an implemented `ur-PK` recognition path for Urdu voice input

### Accounts & records

- **Firebase Authentication** — email/password sign-up, sign-in, password reset, and sign-out
- **Medical Records** — upload documents (camera, gallery, or file picker), store them in the cloud, and list/delete them anytime; decoded documents can be saved here directly from the Document Decoder
- **Profile management** — view and edit the user profile

### Pharmacy (Medicine Orders)

- **Medicine catalog** — browse medicines by category and search medicines, backed by Firestore
- **Cart** — real-time, Firestore-backed cart
- **Checkout** — saved delivery-address management, promo code (`SAVE10`), payment-method selection (Cash on Delivery / card — no payment gateway is integrated; the choice is recorded on the order), and atomic order placement (order write + cart clear in one Firestore batch)

> Screens marked _Order status_, _Order delivery_, _Order returns_, and _Payments & Refunds_ in the Medicine Orders hub are explicitly "in development" placeholders and are not yet implemented.

## Doctor Specialties

The app currently supports exactly these 10 specialties (used for doctor categories, filtering, and AI triage recommendations):

|               |              |                   |              |              |
| ------------- | ------------ | ----------------- | ------------ | ------------ |
| Dermatologist | Dentist      | General Physician | Surgeon      | Orthopedic   |
| Psychologist  | Gynecologist | Neurologist       | Pediatrician | Cardiologist |

## Booking Architecture

Appointment availability and reservations are stored in Firestore as:

```text
doctors/{doctorId}/time_slots/{slotId}          ← recurring master schedule
doctors/{doctorId}/booked_slots/{YYYY-MM-dd_HH-mm}   ← actual booked occurrences
users/{userId}/appointments/{appointmentId}      ← patient appointment records
```

- **`time_slots` is the recurring master schedule.** Each document holds one slot time (e.g. `02:00 PM`). The app treats it as a weekly recurring template: per-weekday availability rules and past-time filtering for "today" are applied on the client.
- **`booked_slots` stores actual booked occurrences.** When a booking is confirmed, a reservation document is created with a deterministic key `YYYY-MM-dd_HH-mm` (built from the appointment date and time), so the same date+time can only ever be reserved once.
- **Efficient Select Time screen.** Opening Select Time performs exactly two Firestore reads: one `getDoctorTimeSlots()` query for the master schedule and one range query over `booked_slots` for the displayed 7-day window (`where('date', >= firstDay, <= lastDay)`).
- **Displayed dates do not trigger individual Firestore queries.** Switching the selected date (or computing per-day available-slot counts) is done entirely from the data already in memory.
- **Final booking uses a Firestore transaction.** `manageSlotsForBooking()` runs a single `runTransaction` that (1) reads the new slot's reservation document, (2) aborts if it already exists ("This time slot is no longer available…"), (3) creates the reservation, (4) releases the old reservation when rescheduling, and (5) writes the appointment document (create for a new booking, update for a reschedule).
- **The transaction prevents race-condition double booking.** Two users confirming the same slot concurrently will serialize via Firestore's optimistic concurrency control; the second transaction sees the first user's reservation and fails cleanly.
- **Cancellation and rescheduling maintain reservation consistency transactionally.** Cancellation (`cancelAppointmentTransactionally()`) updates the appointment status and deletes the matching reservation in one transaction. Rescheduling releases the old slot and reserves the new one in the same transaction as the appointment update; re-selecting the identical date+time is a no-op on the reservation documents. While rescheduling, the appointment's own old slot remains selectable in the UI.

This architecture is intentional: the recurring `time_slots` collection is never modified by bookings — all state changes happen through `booked_slots` reservation documents inside transactions.

## AI Backend

The [Doctor Hunt AI](https://github.com/DevExplorerr/Doctor-Hunt-AI) backend is a standalone Node.js/Express service. Its purpose is to be the single AI gateway: it holds the Alibaba Cloud (Qwen) credentials server-side, enforces validation and rate limits, and returns strictly structured JSON to the app. The Flutter app never sees any AI API key.

**Production backend:** `https://doctor-hunt-ai.onrender.com` (hosted on Render; see [Backend Deployment](#backend-deployment))

### Production API endpoints

| Method | Endpoint               | Body                               | Description                                                                                                                                       |
| ------ | ---------------------- | ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| `GET`  | `/health`              | —                                  | Liveness probe (does **not** call the AI provider)                                                                                                |
| `POST` | `/api/triage/chat`     | `{ sessionId, message, language }` | One triage chat turn; returns `stage`, `aiMessage`, `followUpQuestions`, `urgency`, `specialty`, `triage`, `homeCare`, `language`                 |
| `POST` | `/api/triage/reset`    | `{ sessionId }`                    | Reset a triage session (`404` if the session is unknown/expired)                                                                                  |
| `POST` | `/api/decoder/analyze` | `{ imageUrl }`                     | Analyze a medical document image/PDF (publicly reachable URL); returns the structured analysis described in [AI Document Flow](#ai-document-flow) |

Notes:

- `POST /api/triage/chat` and `POST /api/decoder/analyze` are rate-limited to **10 requests/minute per session** (per IP for the decoder).
- A triage session runs at most **8 turns** and expires after 30 minutes of inactivity.
- Invalid requests return `400 INVALID_REQUEST`; AI-provider failures return generic `502` messages without leaking upstream details.

## Technology Stack

### Mobile (this repository)

| Technology                                                                                                                                        | Purpose                                         |
| ------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| [Flutter](https://flutter.dev) (Dart SDK ≥ 3.10)                                                                                                  | Cross-platform mobile app                       |
| [GetX](https://pub.dev/packages/get)                                                                                                              | State management, dependency injection, routing |
| [Firebase Authentication](https://pub.dev/packages/firebase_auth)                                                                                 | Email/password authentication                   |
| [Cloud Firestore](https://pub.dev/packages/cloud_firestore)                                                                                       | Doctors, appointments, records, cart, orders    |
| [Cloudinary](https://cloudinary.com)                                                                                                              | Medical-record file hosting (unsigned uploads)  |
| [http](https://pub.dev/packages/http)                                                                                                             | REST client for the AI backend                  |
| [speech_to_text](https://pub.dev/packages/speech_to_text)                                                                                         | Voice input for the Symptom Checker             |
| [pdf](https://pub.dev/packages/pdf) + [share_plus](https://pub.dev/packages/share_plus) + [path_provider](https://pub.dev/packages/path_provider) | PDF report generation and sharing               |
| [file_picker](https://pub.dev/packages/file_picker) / [image_picker](https://pub.dev/packages/image_picker)                                       | Document and photo selection/capture            |
| [cached_network_image](https://pub.dev/packages/cached_network_image) / [shimmer](https://pub.dev/packages/shimmer)                               | Image caching and skeleton loading states       |
| [intl](https://pub.dev/packages/intl)                                                                                                             | Date/time parsing and formatting                |
| [flutter_zoom_drawer](https://pub.dev/packages/flutter_zoom_drawer)                                                                               | Side navigation drawer                          |

### Backend ([Doctor-Hunt-AI](https://github.com/DevExplorerr/Doctor-Hunt-AI))

| Technology                                                                                  | Purpose                                                     |
| ------------------------------------------------------------------------------------------- | ----------------------------------------------------------- |
| [Node.js](https://nodejs.org) (18+, CommonJS)                                               | JavaScript runtime (uses the built-in global `fetch`)       |
| [Express 5](https://expressjs.com)                                                          | HTTP framework and routing                                  |
| [cors](https://www.npmjs.com/package/cors) / [dotenv](https://www.npmjs.com/package/dotenv) | CORS handling and environment configuration                 |
| In-memory stores                                                                            | Conversation sessions and rate limiting (reset on redeploy) |

### AI

| Technology                                              | Purpose                                            |
| ------------------------------------------------------- | -------------------------------------------------- |
| Alibaba Cloud Model Studio (OpenAI-compatible endpoint) | AI provider, accessed only from the backend        |
| Qwen `qwen-plus`                                        | Symptom triage (text, structured JSON output mode) |
| Qwen `qwen-vl-plus`                                     | Medical document decoding (vision model)           |

Both models are configurable via environment variables; the app itself has no AI credentials.

## Project Structure

### Flutter app

```text
doctor_hunt/
├── android/                  # Android platform code (permissions, Gradle config)
├── assets/                   # App logo, fonts (Rubik), onboarding & background images
├── lib/
│   ├── controllers/          # GetX controllers (appointments, auth, decoder,
│   │                         #   pharmacy, profile, triage, layout, onboarding)
│   ├── core/
│   │   ├── constants/        # App colors, 10-specialty taxonomy
│   │   ├── theme/            # App theme and text theme
│   │   └── utils/            # Shared helpers
│   ├── data/
│   │   ├── models/           # Doctor, appointment, triage, decoder, pharmacy,
│   │   │                     #   cart, order, address, user, medical-record models
│   │   ├── repositories/     # Firestore/HTTP data access (booking transactions,
│   │   │                     #   auth, doctors, triage, decoder, medical records,
│   │   │                     #   pharmacy, cart, checkout, favorites, users)
│   │   └── services/         # Speech service, decoder PDF report generator
│   ├── presentation/
│   │   ├── screens/          # Feature screens (home, all doctors, doctor details,
│   │   │                     #   select time, appointment details, auth, triage,
│   │   │                     #   medical records, medicine orders/pharmacy/cart/
│   │   │                     #   checkout/decoder, profile, settings, ...)
│   │   └── widgets/          # Reusable UI widgets (buttons, inputs, headers,
│   │                         #   feedback, loading, navigation, search, state)
│   ├── firebase_options.dart # Generated Firebase config (gitignored)
│   └── main.dart             # App entry point, GetX bindings and routes
├── pubspec.yaml              # Dependencies and assets
└── test/                     # Flutter template test only
```

### AI backend

```text
doctor_hunt_ai/
├── src/
│   ├── config/               # Environment-driven configuration
│   ├── middleware/           # Error handler, per-session rate limiter
│   ├── prompts/              # System prompts (triage en/ur, decoder) and
│   │                         #   specialty taxonomy
│   ├── routes/               # /api/triage and /api/decoder routers
│   ├── services/             # Qwen API client, triage service, decoder service,
│   │                         #   conversation store
│   ├── validators/           # Request/response validation and normalization
│   └── server.js             # Express app, /health probe, 0.0.0.0 binding
├── .env.example              # Environment variable template
├── .env                      # Secrets (gitignored, never commit)
└── package.json              # npm scripts and dependencies
```

## Setup & Installation

### Prerequisites

- Flutter SDK (Dart ≥ 3.10, < 4.0) with a connected device or emulator
- A Firebase project (free tier works)
- Node.js 18+ (only needed to run the AI backend locally)

### Flutter app

```bash
git clone https://github.com/DevExplorerr/Doctor-Hunt.git
cd Doctor-Hunt
flutter pub get
```

Firebase configuration is required before the first run — the generated config files are **intentionally gitignored** (`lib/firebase_options.dart`, `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`):

1. Create a Firebase project at the [Firebase console](https://console.firebase.google.com).
2. Register an Android app (package name `com.devexplorerr.doctor_hunt`) and/or an iOS app.
3. Enable **Authentication → Email/Password** and **Cloud Firestore**.
4. Generate the FlutterFire config:

   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

5. Seed Firestore with your data — the app expects the collections listed under [Firebase](#firebase) (at minimum `doctors` documents with `time_slots` subcollections, and the `medicines` catalog for the pharmacy).

Run the app (uses the production AI backend by default):

```bash
flutter run
```

To point the app at a **locally running** AI backend instead:

```bash
flutter run --dart-define=DOCTOR_HUNT_AI_BASE_URL=http://<your-LAN-IP>:3000
```

> Android cleartext HTTP is already permitted in the app manifest for local development. Use your machine's LAN IP (not `localhost`) when running on a physical device.

### AI backend

```bash
git clone https://github.com/DevExplorerr/Doctor-Hunt-AI.git
cd Doctor-Hunt-AI
npm install
cp .env.example .env   # then fill in your values (see below)
npm start              # runs: node src/server.js
```

For development with auto-restart (`nodemon` is included as a dev dependency):

```bash
npx nodemon src/server.js
```

## Environment Variables / Configuration

### AI backend (`doctor_hunt_ai/.env`)

The backend repository includes a [`.env.example`](https://github.com/DevExplorerr/Doctor-Hunt-AI/blob/main/.env.example) template with variable names only. Required variables:

| Variable               | Required | Default        | Purpose                                          |
| ---------------------- | -------- | -------------- | ------------------------------------------------ |
| `ALIBABA_API_KEY`      | Yes      | —              | API key for Alibaba Cloud Model Studio           |
| `ALIBABA_ENDPOINT`     | Yes      | —              | OpenAI-compatible chat-completions endpoint URL  |
| `ALIBABA_MODEL`        | No       | `qwen-plus`    | Text model used for symptom triage               |
| `ALIBABA_VISION_MODEL` | No       | `qwen-vl-plus` | Vision model used for document decoding          |
| `ALIBABA_JSON_MODE`    | No       | `true`         | Structured JSON output mode (`false` to disable) |
| `PORT`                 | No       | `3000`         | Server port (injected by Render in production)   |

### Flutter app

| Dart-define key           | Required | Default                               | Purpose                    |
| ------------------------- | -------- | ------------------------------------- | -------------------------- |
| `DOCTOR_HUNT_AI_BASE_URL` | No       | `https://doctor-hunt-ai.onrender.com` | Base URL of the AI backend |

### Firebase

Firebase configuration is generated per-developer by `flutterfire configure` (see [Setup](#setup--installation)); no Firebase values are hardcoded in this README or the repository.

## Production Configuration

The production Flutter build ships with the production AI backend URL baked in as the compile-time default:

```text
https://doctor-hunt-ai.onrender.com
```

The URL is read through `String.fromEnvironment` in both AI repositories (`TriageRepository` and `DecoderRepository`), so it can be overridden at build time without touching source code:

```bash
flutter run   --dart-define=DOCTOR_HUNT_AI_BASE_URL=https://your-backend.example.com
flutter build apk --release --dart-define=DOCTOR_HUNT_AI_BASE_URL=https://your-backend.example.com
```

If no value is provided, the app always falls back to the production URL — a plain `flutter run` or release build works out of the box against production.

## Firebase

### Services used

- **Firebase Authentication** — email/password accounts (sign-up, sign-in, password reset, sign-out)
- **Cloud Firestore** — all structured app data
- **Cloudinary** (not Firebase Storage) — hosts uploaded medical-record files; Firestore stores only their metadata

### Firestore collections

| Path                                                 | Contents                                                                                                                                                       |
| ---------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `doctors/{doctorId}`                                 | Doctor profile: `name`, `specialty`, `image`, `rating`, `reviews`, `pricePerHour`, `experience`, `services[]`, `isPopular`, `isFeature`, `running`, `patients` |
| `doctors/{doctorId}/time_slots/{slotId}`             | Recurring master schedule (`time`, e.g. `"02:00 PM"`)                                                                                                          |
| `doctors/{doctorId}/booked_slots/{YYYY-MM-dd_HH-mm}` | Slot reservations: `doctorId`, `date`, `time`, `appointmentId`, `userId`                                                                                       |
| `users/{uid}`                                        | Account profile: `uid`, `name`, `email`, `role`, `createdAt`                                                                                                   |
| `users/{uid}/appointments/{appointmentId}`           | Appointments: doctor snapshot, `date`, `time`, `patientName`, `contact`, `patientType`, `status` (`upcoming`/`completed`/`canceled`)                           |
| `users/{uid}/favorites/{doctorId}`                   | Favorite doctor snapshots                                                                                                                                      |
| `users/{uid}/medical_records/{recordId}`             | Record metadata: `title`, `fileUrl` (Cloudinary), `recordType`, `createdAt`                                                                                    |
| `users/{uid}/cart/my_cart`                           | Cart `items[]`                                                                                                                                                 |
| `users/{uid}/addresses/my_addresses`                 | Saved delivery addresses (`list[]`)                                                                                                                            |
| `users/{uid}/orders/{orderId}`                       | Medicine orders: items, totals, `paymentMethod`, `status`, `orderDate`                                                                                         |
| `medicines/{medicineId}`                             | Pharmacy catalog: `category`, `isActive`, pricing, etc.                                                                                                        |

### Security considerations (high level)

- No security rules ship with this repository — deploy rules from your Firebase project and restrict `users/{uid}/**` subcollections (appointments, favorites, records, cart, addresses, orders) to the owning user only.
- `doctors` and `medicines` should be read-only for clients.
- Booking requires authenticated clients to create/delete `booked_slots` reservation documents; scope those rules as tightly as your deployment allows.
- Firebase config files are gitignored in this repository — keep treating them as local, per-project configuration.

## Booking Flow

```text
Doctor
  ↓
Doctor Details
  ↓
Select Time            (2 Firestore reads: master slots + booked slots for the 7-day window)
  ↓
Patient Details        (patient type: My Self / My child / Other, name, contact)
  ↓
Confirm Booking
  ↓
Firestore Transaction  (reserve slot → write appointment; aborts if the slot is taken)
  ↓
Appointment Confirmed
```

- **Cancellation** — one transaction marks the appointment `canceled` and deletes its slot reservation; any failure commits nothing.
- **Rescheduling** — reuses the same flow: one transaction releases the old reservation, reserves the new one, and updates the appointment. Selecting the identical date+time changes nothing.
- **Upcoming appointments** that pass their date/time are displayed as completed.

## AI Document Flow

```text
Upload Document            (camera capture, gallery image, or PDF)
      ↓
Cloudinary Upload          (app uploads the file and receives a public URL)
      ↓
Backend                    (POST /api/decoder/analyze with the image URL)
      ↓
AI Analysis                (Qwen vision model, validated & normalized server-side)
      ↓
Analysis Result            (type, summary, medications, lab findings,
      ↓                     key findings, warnings, confidence, disclaimer)
Copy / Download            (copy to clipboard, export/share a PDF report,
                            or optionally save the record to Medical Records)
```

## Voice Feature

The Symptom Checker supports hands-free input through the device microphone:

- **On-device speech recognition** via the `speech_to_text` plugin, in dictation mode with partial (live) results.
- **Continuous listening** — recognition segments restart automatically (30-second listen window, 6-second pause detection), with deduplication of repeated segments, so users can speak for as long as needed.
- **Live recording panel** — pulsing indicator, elapsed-time counter, and a real-time transcript preview before inserting the text into the chat input.
- **Languages** — recognition runs with the English `en-US` locale by default; the speech service probes the device for Urdu locale support and an `ur-PK` (Urdu, Pakistan) recognition path is implemented for Urdu voice input.
- **Permissions & troubleshooting** — microphone permission is requested on first use; if the device speech service misbehaves, a troubleshooting dialog guides the user to the speech-service app settings.

## Security Notes

- **Never commit `.env`** — it is gitignored in the backend repository; keep it that way.
- **Never commit API keys or secrets.** The Alibaba Cloud AI credentials live only in the backend's environment; the Flutter app contains no AI credentials.
- **Firebase config files are gitignored** in this repository (`google-services.json`, `GoogleService-Info.plist`, `firebase_options.dart`, `key.properties`). Generate your own with `flutterfire configure` and do not commit them.
- **Configure Firestore security rules** before any real deployment (see [Firebase](#firebase)).
- **Production APIs should use HTTPS** — the production backend does (`https://doctor-hunt-ai.onrender.com`). The Android manifest permits cleartext HTTP only to enable local development against a LAN backend; keep that in mind for store review.
- **Debug/test endpoints must not be exposed in production** — the backend's old unauthenticated `/api/test-qwen` debug endpoint was removed; the only unauthenticated routes left are the informational `/` and the `/health` liveness probe.

## Development

```bash
flutter pub get                                       # install dependencies
flutter analyze                                       # static analysis
flutter run                                           # run against the production AI backend
flutter run --dart-define=DOCTOR_HUNT_AI_BASE_URL=http://<LAN-IP>:3000   # local backend
flutter build apk --release                           # release APK
flutter build appbundle --release                     # release AAB (Play Store)
```

> The repository currently contains only Flutter's default template test — there is no meaningful automated test suite yet.

## Release

```bash
flutter build apk --release         # outputs build/app/outputs/flutter-apk/app-release.apk
flutter build appbundle --release   # outputs build/app/outputs/bundle/release/app-release.aab
```

- Android application ID: `com.devexplorerr.doctor_hunt`
- **Signing:** `android/app/build.gradle` currently signs release builds with the debug keystore. This is fine for personal/sideloading use, but a Play Store upload requires a proper upload key — create a keystore, reference it via an (already gitignored) `android/key.properties` file, and never commit the keystore or its passwords.
- Override the backend URL at build time with `--dart-define=DOCTOR_HUNT_AI_BASE_URL=...` if needed (see [Production Configuration](#production-configuration)).

## Backend Deployment

The AI backend is deployed on [Render](https://render.com) and serves the production URL used by the app:

```text
https://doctor-hunt-ai.onrender.com
```

Render configuration used by this project:

| Setting               | Value                                                                                                                                      |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| Build command         | `npm install`                                                                                                                              |
| Start command         | `npm start`                                                                                                                                |
| Health check path     | `/health`                                                                                                                                  |
| Environment variables | `ALIBABA_API_KEY`, `ALIBABA_ENDPOINT` (plus optional model overrides — see [Environment Variables](#environment-variables--configuration)) |
| `PORT`                | Injected automatically by Render                                                                                                           |

Notes:

- The service binds to `0.0.0.0` and exposes `/health` as a lightweight liveness probe that does not call the AI provider, so third-party outages do not trigger platform restarts.
- Conversation sessions and rate-limit counters are in-memory and reset on every redeploy.

## Future Improvements

- Implement the medicine-order tracking screens currently shown as "in development" (order status, delivery, returns, payments & refunds).
- Expose the already-implemented Urdu (`ur-PK`) speech recognition path through an in-app voice language selector.

## License

This repository currently has no explicit license. Contact the author if you want to use the code.

## Author

**DevExplorerr** — [GitHub](https://github.com/DevExplorerr)

Related project: [Doctor Hunt AI](https://github.com/DevExplorerr/Doctor-Hunt-AI) (backend)
