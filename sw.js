// Guarda os arquivos da interface e cacheia músicas tocadas sob demanda
const CACHE = 'ritmo-mp3-v6';
const AUDIO_CACHE = 'ritmo-mp3-audio-v1';
const FILES = [
  './',
  'index.html',
  'manifest.webmanifest',
  'icon-180.png',
  'icon-192.png',
  'icon-512.png',
  'bg-partitura.jpg',
  'musicas.json'
];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(FILES)).then(() => self.skipWaiting()));
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(
        keys.filter(k => k !== CACHE && k !== AUDIO_CACHE).map(k => caches.delete(k))
      ))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', e => {
  if (e.request.method !== 'GET') return;
  const url = new URL(e.request.url);
  const isAudio = url.pathname.includes('/musicas/') || /\.(mp3|m4a|wav|aac)$/i.test(url.pathname);
  const targetCache = isAudio ? AUDIO_CACHE : CACHE;

  // Para áudios já baixados, tenta cache primeiro para abrir instantaneamente; para o resto, rede primeiro
  if (isAudio) {
    e.respondWith(
      caches.open(AUDIO_CACHE).then(async c => {
        const cached = await c.match(e.request, { ignoreSearch: true });
        if (cached) return cached;
        const r = await fetch(e.request);
        if (r && r.status === 200) c.put(e.request, r.clone()).catch(() => {});
        return r;
      })
    );
    return;
  }

  e.respondWith(
    fetch(e.request)
      .then(r => {
        if (r && r.status === 200) {
          const copy = r.clone();
          caches.open(targetCache).then(c => c.put(e.request, copy)).catch(() => {});
        }
        return r;
      })
      .catch(() => caches.match(e.request, { ignoreSearch: true }))
  );
});
