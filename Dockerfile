# ========= ARGUMENTE =========
ARG RUSTv=1.82
ARG NODEv=23-alpine

# ========= STAGE 1: Rust-Basis-Setup =========
FROM rust:${RUSTv} AS rust-base

# Arbeitsverzeichnis setzen
WORKDIR /app

# Abhängigkeiten wie bei `npm install` laden
RUN cargo install cargo-watch

# ========= STAGE 2: Node.js-Basis-Setup =========
FROM node:${NODEv} AS node-base

# Arbeitsverzeichnis setzen
WORKDIR /app

# package.json kopieren und Abhängigkeiten installieren
COPY package*.json ./
RUN npm install

# ========= FINAL STAGE: Kombination aus Rust und Node.js =========
FROM rust:${RUSTv} AS final

# Arbeitsverzeichnis setzen
WORKDIR /app

# Rust-Tools aus rust-base kopieren
COPY --from=rust-base /usr/local /usr/local

# Node.js-Tools aus node-base kopieren
COPY --from=node-base /usr/local /usr/local

# Setze den PATH für Node.js und npm
ENV PATH="/usr/local/bin:${PATH}"

# Projektcode kopieren
COPY . .

# Rust-Build ausführen
# RUN cargo build --release (entfernt für Entwicklungszwecke)

# Optional: Node.js-Build (falls notwendig, z. B. für Frontend-Projekte)
# RUN npm run build (nicht benötigt für Entwicklung)

# Standardbefehl zum Starten der Anwendung
CMD ["cargo", "run"]
