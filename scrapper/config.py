"""
Configuration du scraper de plantes
"""

# URL de base pour la recherche
SEARCH_BASE_URL = "https://www.promessedefleurs.com/search/ajax/suggest/"

# Headers par défaut
HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36"
    )
}

# Délai entre chaque requête (en secondes) — soyez respectueux du site !
DELAI_ENTRE_REQUETES = 2

# Chemin de la base de données
DB_PATH = "assets/plantes.db"

# Texte de recherche par défaut
SEARCH_TEXT = "magnolia"
