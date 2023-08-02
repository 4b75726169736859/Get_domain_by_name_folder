#!/bin/bash

# Vérifie que l'argument est fourni
if [ $# -ne 1 ]; then
  echo "Usage: $0 <Chemin>"
  exit 1
fi

# Chemin donné en argument
chemin="$1"

# Expression régulière pour vérifier les noms de domaine et sous-domaines
domain_regex='^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$'

# Compteur pour les noms de domaine
counter=0

# Fonction pour vérifier et afficher les noms de domaine et sous-domaines
check_domain() {
  local folder="$1"
  if [[ "$folder" =~ $domain_regex ]]; then
    echo "Domaine trouvé : ${BASH_REMATCH[0]}"
    ((counter++))
    echo "${BASH_REMATCH[0]}" >> all_domaine.txt
  fi
}

# Supprime le fichier all_domaine.txt s'il existe déjà
if [ -e "all_domaine.txt" ]; then
  rm "all_domaine.txt"
fi

# Utiliser ls pour obtenir les dossiers, y compris les liens symboliques et les liens directs
for folder in "$chemin"/*/; do
  # Vérification si le dossier existe
  if [ -d "$folder" ]; then
    # Obtention du nom du dossier sans le chemin complet
    folder_name=$(basename "$folder")
    check_domain "$folder_name"
  fi
done

echo "Nombre total de noms de domaine et sous-domaines trouvés : $counter"
