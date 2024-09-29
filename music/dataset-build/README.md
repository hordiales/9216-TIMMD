# Paso a paso para construir un Dataset

    * Recolectar IDs de artistas de spotify
    * Agregar IDs en dict archivos: 
        self.artist_catalogue = @ 1_spotify_30sec_samples_download.py 

## Instalar dependencias

    $ pip install -r requirements.txt

## Credenciales Spotify

Generar credenciales en la página de Spotify y exportarlas para que esten disponibles en la sesión

    export SPOTIPY_CLIENT_ID=""
    export SPOTIPY_CLIENT_SECRET=""

## Bajar samples de Spotify por artista 

    $ python 1_spotify_30sec_samples_download.py 

* Baja archivos .mp3 en sample_audio/[Artist]
* Genera metadata en track_data/[Artist]/[SpotifyId].json

## 