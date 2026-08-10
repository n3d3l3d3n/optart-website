# OptArt+ (OPT) — Site web

Site statique mono-page pour le token OptArt+ sur Solana.

## Contenu
- `index.html` — page d'accueil (tokenomics, utilité, roadmap, liens)
- `whitepaper.md` — whitepaper
- `assets/logo.png` — logo officiel
- `token_metadata.json` — metadata Metaplex (remplir l'URL image)

## Hébergement (GitHub Pages, gratuit)
1. Créer un repo `optart-website` sur GitHub
2. Pousser ce dossier
3. Settings > Pages > source: branch main, dossier `/ (root)`
4. Le site sera sur `https://<user>.github.io/optart-website/`
5. URL du logo : `https://<user>.github.io/optart-website/assets/logo.png`
   → mettre cette URL dans `token_metadata.json` (champ `image` + `properties.files[0].uri`)

## Metadata on-chain
Une fois l'URL du logo connue, remplacer `REPLACE_WITH_IPFS_OR_ARWEAVE_URL`
dans `token_metadata.json`, puis lancer `create_token.sh`.

## Notes
- Le wallet créateur : `8ZVHxD8jUH64HiZekgJoqXA4j8CGUViPp8ap8S5aHeg9`
- Mint authority sera renoncée après le mint (supply fixe).
