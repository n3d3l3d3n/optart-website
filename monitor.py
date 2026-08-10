#!/usr/bin/env python3
"""OptArt+ (OPT) launch monitoring.
Suit le prix + liquidité via Jupiter API et la solvabilité du wallet.
Usage: python monitor.py <MINT_ADDRESS> [--cluster mainnet]
"""
import sys, time, json, urllib.request

def get_json(url, timeout=20):
    req = urllib.request.Request(url, headers={"User-Agent":"optart-monitor"})
    return json.load(urllib.request.urlopen(req, timeout=timeout))

def price_usd(mint):
    # Jupiter price API (mainnet)
    url = f"https://price.jup.ag/v6/price?ids={mint}"
    try:
        d = get_json(url)
        return d.get("data", {}).get(mint, {}).get("price")
    except Exception as e:
        return f"err:{e}"

def liquidity(mint, cluster="mainnet-beta"):
    # tentative via Solana RPC getTokenAccounts (simplifie)
    rpc = "https://api.mainnet-beta.solana.com" if cluster=="mainnet-beta" else "https://api.devnet.solana.com"
    payload = {"jsonrpc":"2.0","id":1,"method":"getTokenSupply",
               "params":[mint]}
    try:
        req = urllib.request.Request("https://api.mainnet-beta.solana.com",
            data=json.dumps(payload).encode(), headers={"Content-Type":"application/json"})
        d = json.load(urllib.request.urlopen(req, timeout=20))
        return d.get("result", {}).get("value", {})
    except Exception as e:
        return {"error": str(e)}

def main():
    if len(sys.argv) < 2:
        print("Usage: python monitor.py <MINT_ADDRESS>"); sys.exit(1)
    mint = sys.argv[1]
    print(f"=== OptArt+ monitoring: {mint} ===")
    while True:
        p = price_usd(mint)
        print(f"[{time.strftime('%H:%M:%S')}] Prix USD: {p}")
        sup = liquidity(mint)
        print(f"  Supply on-chain: {sup}")
        time.sleep(30)

if __name__ == "__main__":
    main()
