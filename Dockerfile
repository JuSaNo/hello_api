# 1) Perusimage
FROM python:3.11-slim AS runtime

# 2) Työhakemisto
WORKDIR /app

# 3) Kopioi riippuvuudet ja asenna
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 4) Kopioi sovellus
COPY app.py ./app.py

# 5) Expose & käynnistys
EXPOSE 5000
CMD ["python", "app.py"]
