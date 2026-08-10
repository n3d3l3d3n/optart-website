#!/usr/bin/env bash
# OptArt+ (OPT) — creation du token SPL sur Solana mainnet
# Pre-requis: solana CLI + spl-token installes, wallet finance en SOL.
# Le wallet cree (id.json) doit etre dans ~/.config/solana/ ou specifie via --keypair.
#
# ATTENTION: ce script est pret a lancer MAIS necessite:
#   1) solana CLI installe (https://docs.solana.com/cli/install)
#   2) wallet finance en SOL (adresse: 8ZVHxD8jUH64HiZekgJoqXA4j8CGUViPp8ap8S5aHeg9)
#   3) metadata JSON rempli (URL image IPFS/Arweave)
#
# Usage: bash create_token.sh

set -e
KEYPAIR="$HOME/.optart_vault/id.json"
SUPPLY=1000000000        # 1 milliard
DECIMALS=9
NAME="OptArt+"
SYMBOL="OPT"

echo "[1] Configuration cluster mainnet"
solana config set --url mainnet-beta
solana config set --keypair "$KEYPAIR"

echo "[2] Solde du wallet (doit etre > 0.02 SOL):"
solana balance

echo "[3] Creation du token SPL ($NAME / $SYMBOL)"
# decimals=9, supply total en unites de base (1e9 * 1e9 = 1e18)
MINT=$(spl-token create-token --decimals $DECIMALS --enable-metadata "$KEYPAIR" | grep -oE 'Creating token (.*)' | awk '{print $3}')
echo "MINT = $MINT"

echo "[4] Creation du compte associé (ATA)"
spl-token create-account "$MINT"

echo "[5] Mint du supply total"
spl-token mint "$MINT" $((SUPPLY * 10**DECIMALS))

echo "[6] Metadata on-chain (Metaplex)"
spl-token initialize-metadata "$MINT" "$NAME" "$SYMBOL" "REPLACE_WITH_IPFS_OR_ARWEAVE_URL"

echo "[7] (Optionnel) Renonce a la mint authority pour supply fixe:"
# spl-token authorize "$MINT" mint --disable

echo "=== TERMINÉ ==="
echo "Mint address: $MINT"
echo "Explorer: https://explorer.solana.com/address/$MINT"
