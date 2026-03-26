"""
Scraper de fiches plantes
=================================================
Auteur : app_jar project
Usage  : python scraper_plantes.py

Ce script :
  1. Scrape une ou plusieurs fiches plantes à partir d'une recherche (cf. fichier config.py)
  2. Nettoie et structure les données avec pandas
  3. Stocke tout dans une base SQLite locale (plantes.db)

Dépendances :
  pip install requests beautifulsoup4 pandas
"""

import requests
from bs4 import BeautifulSoup
import pandas as pd
import sqlite3
import time
import re
import os
from config import SEARCH_BASE_URL, HEADERS, DELAI_ENTRE_REQUETES, DB_PATH, SEARCH_TEXT

# ─────────────────────────────────────────────
# CONFIGURATION
# ─────────────────────────────────────────────
# Les configurations sont chargées depuis config.py

# ─────────────────────────────────────────────
# LISTE DES URLs À SCRAPER
# ─────────────────────────────────────────────

def get_urls_from_search(search_text: str) -> list:
    search_url = f"{SEARCH_BASE_URL}?q={search_text}"

    response = requests.get(search_url)
    if response.status_code == 200: 
        data = response.json()
        URLS = [item['url'] for item in data if item.get("type") == "product"]

    else :
        print(f"Erreur lors de la requête : {response.status_code}")
    return URLS


# ─────────────────────────────────────────────
# SCRAPING D'UNE FICHE PLANTE
# ─────────────────────────────────────────────

def scraper_fiche(url: str) -> dict | None:
    """
    Récupère et analyse une fiche plante depuis son URL.
    Retourne un dictionnaire avec toutes les caractéristiques trouvées,
    ou None si la page n'a pas pu être chargée.
    """
    print(f"\n🌿 Scraping : {url}")

    try:
        response = requests.get(url, headers=HEADERS, timeout=15)
        print(f"  ✅ Page chargée avec succès (code {response.status_code})")
        response.raise_for_status()
    except requests.RequestException as e:
        print(f"  ❌ Erreur de connexion : {e}")
        return None

    soup = BeautifulSoup(response.text, "html.parser")

    plante = {"url": url}

    # ── Nom de la plante ──────────────────────────────────────────────
    h1 = soup.find("h1")
    plante["nom_complet"] = h1.get_text(strip=True) if h1 else None
    print(f"  📌 Nom complet : {plante['nom_complet']}")

    # Nom Latin
    h2 = soup.find("h2")
    h2.span.decompose()
    plante["nom_latin"] = h2.get_text(strip=True) if h2 else None

    # ── Caractéristiques techniques ───────────────────────────────────

    champs_cibles = {
        "hauteur":              ["hauteur à maturité"],
        "largeur":              ["largeur à maturité"],
        "croissance":           ["croissance"],
        "couleur_fleur":        ["fleur de couleur"],
        "periode_floraison":    ["période de floraison"],
        "type_inflorescence":   ["inflorescence"],
        "persistance_feuillage":["persistance feuillage"],
        "couleur_feuillage":    ["feuillage de couleur"],
        "periode_plantation":   ["période de plantation"],
        "rusticite":            ["rusticité"],
        "exposition":           ["exposition"],
        "ph_sol":               ["ph du sol"],
        "type_sol":             ["type de sol"],
        "humidite_sol":         ["humidité du sol"],
        "taille":               ["taille"],
        "desc_taille":          ["descriptif taille"],
        "periode_taille":       ["période de taille"],
    }

    # Initialisation à None
    for champ in champs_cibles:
        plante[champ] = None

    # Recherche dans le corps de page, les éléments de type tableau ou liste de specs
    try:
        main_content = soup.body.main if soup.body and soup.body.main else soup.body
        if main_content:
            # Chercher les éléments avec id="description" ET id="instruction"
            desc_elements = []
            for element_id in ["description", "instruction"]:
                elem = main_content.find(id=element_id)
                if elem:
                    desc_elements.append(elem)
            
            for desc_elem in desc_elements:
                elements = desc_elem.find_all(class_="u-alternate-rows")
                #extraction des spans qui contiennent les caractéristiques
                for rows in elements:
                    spans = rows.find_all("span")
                    #extraction du texte de chaque span et recherche des mots-clés
                    for el in spans:
                        texte = el.get_text(separator=" ", strip=True).lower()

                        for champ, mots_cles in champs_cibles.items():
                            if plante[champ]:  # déjà trouvé, on passe
                                continue
                            for mot in mots_cles:
                                if mot in texte and len(texte) < 200:
                                    # On prend le texte de l'élément suivant si disponible
                                    valeur = None
                                    suivant = el.find_next_sibling()
                                    if suivant:
                                        valeur = suivant.get_text(separator=" ",strip=True)
                                    if not valeur:
                                        # Sinon on prend tout le texte de l'élément
                                        valeur = el.get_text(strip=True)
                                    plante[champ] = valeur[:300]  # limite à 300 chars
                                    break
    except AttributeError as e:
        print(f"  ⚠️  Impossible d'extraire les caractéristiques : {e}")
        print("  🔎 Caractéristiques techniques extraites")


    # ── Description ───────────────────────────────────────────────────
    # Chercher le bloc de description principal
    desc = None
    for balise in ["description", "product-description", "desc", "detail"]:
        bloc = soup.find(class_=re.compile(balise, re.I))
        if bloc:
            desc = bloc.get_text(separator=" ", strip=True)
            break

    if not desc:
        # Chercher les paragraphes longs (probablement la description)
        paragraphes = [p.get_text(strip=True) for p in soup.find_all("p") if len(p.get_text(strip=True)) > 100]
        desc = " ".join(paragraphes[:3]) if paragraphes else None

    plante["description"] = desc[:1000] if desc else None  # limite à 1000 chars

    print(f"  ✅ Scraping terminé : {len([v for v in plante.values() if v])} champs remplis")
    return plante


# ─────────────────────────────────────────────
# NETTOYAGE DES DONNÉES
# ─────────────────────────────────────────────

def nettoyer_donnees(df: pd.DataFrame) -> pd.DataFrame:
    print("\n🧹 Nettoyage des données...")
    
    # Remplacer les chaînes vides par NaN
    df = df.replace(r'^\s*$', None, regex=True)
    
    # Supprimer les doublons sur l'URL
    df = df.drop_duplicates(subset=['url'], keep='first')
    
    print(f"  ✅ {len(df)} ligne(s) après nettoyage")
    return df

# ─────────────────────────────────────────────
# STOCKAGE DANS SQLITE
# ─────────────────────────────────────────────

def initialiser_base(conn: sqlite3.Connection):
    """
    Crée les tables SQLite si elles n'existent pas encore.
    """
    conn.execute("""
        CREATE TABLE IF NOT EXISTS plantes (
            id                  INTEGER PRIMARY KEY AUTOINCREMENT,
            url                 TEXT UNIQUE,
            nom_complet         TEXT,
            nom_latin           TEXT,
            hauteur             TEXT,
            largeur             TEXT,
            croissance          TEXT,
            couleur_fleur       TEXT,
            periode_floraison   TEXT,
            type_inflorescence  TEXT,
            persistance_feuillage TEXT,
            couleur_feuillage   TEXT,
            periode_plantation TEXT,
            rusticite          TEXT,
            exposition         TEXT,
            ph_sol             TEXT,
            type_sol           TEXT,
            humidite_sol       TEXT,
            taille             TEXT,
            desc_taille        TEXT,
            periode_taille     TEXT,
            description        TEXT,
            date_scraping      TEXT DEFAULT CURRENT_TIMESTAMP
        )
    """)
    conn.commit()
    print("  ✅ Base SQLite initialisée")


def sauvegarder_en_base(df: pd.DataFrame, db_path: str):
    """
    Insère ou met à jour les plantes dans la base SQLite.
    """
    print(f"\n💾 Sauvegarde dans '{db_path}'...")

    conn = sqlite3.connect(db_path)
    initialiser_base(conn)

    for _, row in df.iterrows():
        data = row.to_dict()

        # Colonnes attendues dans la table
        colonnes = [
            "url", "nom_complet", "nom_latin",
            "hauteur", "largeur", "croissance", "couleur_fleur",
            "periode_floraison", "type_inflorescence", 
            "persistance_feuillage", "couleur_feuillage",
            "periode_plantation", "rusticite", "exposition",
            "ph_sol", "type_sol", "humidite_sol",
            "taille", "desc_taille", "periode_taille",
            "description"
        ]

        valeurs = {col: data.get(col) for col in colonnes}

        placeholders = ", ".join([f":{col}" for col in colonnes])
        cols_str = ", ".join(colonnes)
        update_str = ", ".join([f"{col} = :{col}" for col in colonnes if col != "url"])

        conn.execute(f"""
            INSERT INTO plantes ({cols_str})
            VALUES ({placeholders})
            ON CONFLICT(url) DO UPDATE SET {update_str}
        """, valeurs)

    conn.commit()

    # Vérification
    total = conn.execute("SELECT COUNT(*) FROM plantes").fetchone()[0]
    print(f"  ✅ {total} plante(s) au total dans la base")

    conn.close()


# ─────────────────────────────────────────────
# PROGRAMME PRINCIPAL
# ─────────────────────────────────────────────

def main():
    print("=" * 55)
    print("  🌸 Scraper Plantes ")
    print("=" * 55)

    resultats = []

    #lancer la recherche pour obtenir les URLs à scraper
    URLS =get_urls_from_search(SEARCH_TEXT)

    #scrapper les URLs
    for i, url in enumerate(URLS):
        donnees = scraper_fiche(url)
        if donnees:
            resultats.append(donnees)

        # Pause entre les requêtes (sauf pour la dernière)
        if i < len(URLS) - 1:
            print(f"  ⏳ Pause {DELAI_ENTRE_REQUETES}s...")
            time.sleep(DELAI_ENTRE_REQUETES)

    if not resultats:
        print("\n❌ Aucune donnée récupérée.")
        return

    # Créer le DataFrame pandas
    df = pd.DataFrame(resultats)
    print(f"\n📋 DataFrame créé : {df.shape[0]} ligne(s), {df.shape[1]} colonne(s)")

    # Nettoyer
    df = nettoyer_donnees(df)

    # Sauvegarder en SQLite
    sauvegarder_en_base(df, DB_PATH)

    print(f"\n✨ Terminé ! Base de données : '{os.path.abspath(DB_PATH)}'")

if __name__ == "__main__":
    main()
