<div align="center">

<img src="icon-192.png" alt="Ritmo MP3" width="96" height="96">

# 🎸 Ritmo MP3

**Jogo de ritmo estilo Guitar Flash / Beatstar no navegador que gera notas automaticamente a partir de qualquer música MP3, M4A, WAV ou OGG.**

![HTML5 Canvas](https://img.shields.io/badge/HTML5-Canvas%202D-e34f26?style=flat-square&logo=html5&logoColor=white)
![Web Audio API](https://img.shields.io/badge/Web%20Audio-DSP%20%2F%20MIR-4caf7a?style=flat-square)
![PWA Ready](https://img.shields.io/badge/PWA-Offline%20Ready-4a90e2?style=flat-square)
![Zero Dependências](https://img.shields.io/badge/Depend%C3%AAncias-Zero-e6c84a?style=flat-square)

</div>

---

## ✨ Recursos

- 🎵 **Biblioteca integrada + arquivos locais:** jogue as **34 faixas** da biblioteca (`musicas.json`) ou carregue qualquer arquivo de áudio do seu celular/computador via **+ Arquivo**.
- 🧠 **Geração automática de notas (DSP / MIR):** analisa o áudio em tempo real no navegador sem servidor nem dependências externas:
  - **Banco de 8 sub-bandas musicais** (`<105 Hz` até `>6800 Hz`) + separação estéreo **Mid/Side** para destacar guitarras, baixo e bateria.
  - **Detecção de bateria e palhetadas:** identifica bumbo, caixa, chimbal/pratos e ataques de cordas.
  - **Contorno melódico (subidas e descidas):** acompanha a mudança de altura das notas nas 4 cordas (`0 → 1 → 2 → 3` nas subidas e `3 → 2 → 1 → 0` nas descidas).
  - **Ellis Dynamic Programming Beat Tracker:** acompanha variações reais de andamento da música e calcula o BPM automaticamente.
- 🎚️ **3 níveis de dificuldade:** **Fácil**, **Médio** (padrão) e **Difícil**.
- 🏆 **Recordes salvos por dificuldade:** guarda no `localStorage` a melhor pontuação, precisão e maior combo de cada música separadamente para Fácil, Médio e Difícil, exibindo os recordes direto na lista.
- 🎨 **Visual temático de guitarra:** divisórias em estilo cordas metálicas encapadas que vibram ao acertar as notas, fundo escuro com partitura, efeitos de partículas, ondas de choque e avisos especiais nos combos de **10, 25, 50 e 100 notas**.
- 🎧 **Ajuste de sincronia (latência):** compensação de `-200 ms` a `+200 ms` para fones Bluetooth.
- 📱 **PWA instalável:** funciona em tela cheia no celular (Android e iOS) com cache offline via Service Worker (`sw.js`).

---

## 🎮 Controles

| Plataforma | Ação |
| :--- | :--- |
| **Celular / Tablet** | Toque diretamente em cada uma das 4 pistas na parte inferior (suporta multitoque para acordes/notas rápidas) |
| **Teclado (PC)** | `D` `F` `J` `K` para as 4 cordas · `P` ou `Esc` para pausar |

---

## 🚀 Como rodar localmente

Por usar `fetch('musicas.json')` e Service Worker, abra o projeto através de um servidor HTTP local (em vez de abrir `index.html` diretamente via `file://`):

```powershell
# Exemplo com Python
python -m http.server 8080
```

Depois acesse `http://localhost:8080` no navegador.

### 📱 Como instalar no iPhone / Android (PWA)

1. Publique a pasta em um endereço **HTTPS** (GitHub Pages, Netlify Drop, Vercel ou Cloudflare Pages).
2. Abra o link no **Safari** (iOS) ou **Chrome** (Android).
3. Toque em **Compartilhar → Adicionar à Tela de Início** (iOS) ou **Instalar aplicativo** (Android).

> **Dica:** fones Bluetooth costumam adicionar atraso no áudio. Use o controle **🎧 Sincronia (atraso)** no menu para ajustar em passos de `10 ms`.

---

## 📂 Adicionando novas músicas à biblioteca

1. Coloque os arquivos `.mp3`, `.m4a`, `.wav`, `.aac` ou `.ogg` dentro da pasta `musicas/`.
2. Execute o script PowerShell para atualizar o `musicas.json` automaticamente:

```powershell
.\atualizar-musicas.ps1
```

---

## 🗂️ Estrutura do projeto

```text
ritmo/
├── index.html             # Interface, motor DSP/MIR de geração de notas e renderização Canvas 2D
├── musicas.json           # Catálogo das faixas da biblioteca
├── musicas/               # Arquivos de áudio da biblioteca
├── atualizar-musicas.ps1  # Script PowerShell para gerar musicas.json a partir de musicas/
├── sw.js                  # Service Worker (cache da interface e das músicas tocadas)
├── manifest.webmanifest   # Configuração do PWA
├── bg-partitura.jpg       # Arte de fundo
├── icon-180.png           # Ícone Apple Touch
├── icon-192.png           # Ícone PWA
└── icon-512.png           # Ícone PWA alta resolução
```
