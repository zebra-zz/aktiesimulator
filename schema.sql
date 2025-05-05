-- Skapa användarkonton
CREATE TABLE konton (
    kontoid TEXT PRIMARY KEY,
    nyckel TEXT NOT NULL,
    skapad TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Bokföring enligt dubbel bokföring
CREATE TABLE bokforing (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    kontoid TEXT NOT NULL,
    kontoslag TEXT CHECK (kontoslag IN ('T', 'S', 'K', 'I')) NOT NULL,
    artikel TEXT NOT NULL,
    volym REAL NOT NULL,
    varde REAL NOT NULL,
    valuta TEXT NOT NULL,
    tidpunkt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (kontoid) REFERENCES konton(kontoid)
);

-- Ordertabell för köp/sälj
CREATE TABLE orderbok (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    kontoid TEXT NOT NULL,
    typ TEXT CHECK (typ IN ('KÖP', 'SÄLJ')) NOT NULL,
    artikel TEXT NOT NULL,
    volym REAL NOT NULL,
    pris REAL NOT NULL,
    valuta TEXT NOT NULL,
    aktiv INTEGER DEFAULT 1,
    skapad TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (kontoid) REFERENCES konton(kontoid)
);

-- Loggade avslut (matcherade ordrar)
CREATE TABLE avslut (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    kope_order INTEGER,
    salj_order INTEGER,
    artikel TEXT,
    volym REAL,
    pris REAL,
    valuta TEXT,
    tidpunkt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (kope_order) REFERENCES orderbok(id),
    FOREIGN KEY (salj_order) REFERENCES orderbok(id)
);

-- Tabell med aktier och valutor
CREATE TABLE IF NOT EXISTS instrument (
    id TEXT PRIMARY KEY,            -- t.ex. AAPL, SEK
    namn TEXT NOT NULL,             -- t.ex. Apple Inc., Svenska Kronan
    typ TEXT NOT NULL,              -- 'aktie' eller 'valuta'
    valuta TEXT NOT NULL,           -- t.ex. SEK, USD
    pris REAL NOT NULL,             -- senaste pris
    senast_uppdaterad TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabell med prishistorik för varje instrument
CREATE TABLE IF NOT EXISTS instrument_hist (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    instrument_id TEXT NOT NULL,
    tidpunkt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    pris REAL NOT NULL,
    FOREIGN KEY (instrument_id) REFERENCES instrument(id)
);
