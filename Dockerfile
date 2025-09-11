FROM python:3.11-slim

# Installer socat et utilitaires (nettoyage pour image légère)
RUN apt-get update \
 && apt-get install -y --no-install-recommends socat gcc libffi-dev libssl-dev \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copier le code du projet
COPY . /app

# Installer les dépendances Python si présentes
# (le repo contient requirements.txt / setup)
RUN if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi || true
# fallback : tenter d'installer le package si présent
RUN if [ -f setup.py ]; then pip install --no-cache-dir .; fi || true

# Copier l'entrypoint custom
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 8000

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
# On laisse la possibilité de passer les mêmes args qu'avant (ex: -t http -p 8000)
CMD ["-t","http","-p","8000"]
