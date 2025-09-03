FROM python:stretch

# Arbeitsverzeichnis
WORKDIR /app

# Abhängigkeiten kopieren & installieren
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# Build-Arg um JWT_SECRET in image zu setzen (wird beim build übergeben)
ARG JWT_SECRET
ENV JWT_SECRET=${JWT_SECRET}

# Quellcode kopieren
COPY . /app

# Schreibe ein secrets-file, falls deine App das braucht (kann auch in runtime als env gelesen werden)
RUN mkdir -p /run/secrets && printf '%s' "${JWT_SECRET}" > /run/secrets/jwt_secret && chmod 600 /run/secrets/jwt_secret

# Port
EXPOSE 8080

# Entrypoint: benutze Gunicorn wie verlangt
ENTRYPOINT ["gunicorn", "-b", ":8080", "main:APP"]
