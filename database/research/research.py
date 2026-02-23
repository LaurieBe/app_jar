"""
script pour utiliser l'api de recherche du site promessedefleurs.com
pour obtenir les urls de fiches plantes à fournir à scraper_plantes.py

"""

import requests

search_text = "geranium"
search_url = f"https://www.promessedefleurs.com/search/ajax/suggest/?q={search_text}"

response = requests.get(search_url)
if response.status_code == 200: 
    data = response.json()
    url_list = [item['url'] for item in data if item.get("type") == "product"]
    print(url_list)

else :
    print(f"Erreur lors de la requête : {response.status_code}")