# MedBot

MedBot is an AI-powered medical assistant that provides instant, transparent, and reliable information derived from trusted government, institutional, and peer-reviewed sources. The system is built for accessibility, transparency, and responsible AI usage.

---

## Features

* AI-powered chatbot for medical queries
* Retrieval-Augmented Generation (RAG) pipeline
* References to verified, trustworthy medical sources
* Responsive Flutter Web frontend
* FastAPI backend for secure and scalable API endpoints
* MongoDB for chat history and context storage
* Markdown, LaTeX, and rich answer formatting
* User feedback and crowdsourced improvement

---

## Technology Stack

* **Frontend:** Flutter Web
* **Backend:** FastAPI (Python)
* **Database:** MongoDB (Atlas/Cloud/Local)
* **State Management:** Provider (Flutter)
* **Markdown Rendering:** flutter\_markdown
* **API Communication:** HTTP requests (REST)
* **Authentication:** Optional JWT integration (future)
* **CI/CD:** Compatible with Netlify, Firebase Hosting, Render, Vercel

---

## Project Structure

```
/medbot
  /lib
    /pages
    /widgets
    main.dart
    theme_provider.dart
  /build
  /assets
  pubspec.yaml

/backend
  main.py
  db.py
  requirements.txt
  .env
```

---

## Setup and Deployment

### Frontend (Flutter Web)

1. Install [Flutter SDK](https://flutter.dev/docs/get-started/install)
2. Clone the repository
3. Navigate to the `medbot` directory
4. Install dependencies:

   ```bash
   flutter pub get
   ```
5. Run locally:

   ```bash
   flutter run -d chrome
   ```
6. Build for web deployment:

   ```bash
   flutter build web
   ```
7. Deploy `build/web` to Netlify, Firebase Hosting, or Vercel

### Backend (FastAPI)

1. Navigate to the `backend` directory
2. Install dependencies:

   ```bash
   pip install -r requirements.txt
   ```
3. Set up your `.env` file with your MongoDB connection string and secrets
4. Run the API:

   ```bash
   uvicorn main:app --host 0.0.0.0 --port 10000
   ```
5. Backend will be available at `http://localhost:10000`

---

## Environment Variables

Create a `.env` file in `/backend` and set:

```
MONGODB_URI=your_mongodb_uri
OTHER_SECRET=your_secret_if_needed
```

---

## Contribution

* Fork the repository
* Create a feature branch (`git checkout -b feature/your-feature`)
* Commit changes and push (`git push origin feature/your-feature`)
* Open a pull request with clear description of your changes

---

## Maintainer

[Sayak Mondal](https://www.aisayak.in) | [GitHub](https://github.com/ElixerAxiomCalculus)
