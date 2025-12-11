# cropgains

Track your Chia farming rewards and calculate profitability including energy costs.

## Features

- **Wallet monitoring** – Track XCH received over 24h, 7 days, and 30 days
- **Profit calculation** – Rewards minus electricity costs
- **Energy tracking** – Integrates with Tasmota smart plugs for real-time power monitoring
- **Effective farm size** – Calculate your equivalent plot count based on rewards

## Usage

```bash
cropgains
```

Runs in the terminal and displays a dashboard with your farming stats.

## Configuration

Create a config file at one of these locations:
- `/etc/chiagarden/cropgains.config`
- `~/.config/chiagarden/cropgains.config`
- `./cropgains.config`

### Example Config

```ini
[DEFAULT]
WALLET_ADDRESS = xch1your_wallet_address_here
ELECTRICITY_PRICE_USD = 0.12

[DEVICES_IP]
# Tasmota smart plugs for real-time energy monitoring
farmer = 192.168.1.100
plotter = 192.168.1.101

[DEVICES_POWER_DRAW]
# Static power draw in watts (if no smart plug)
router = 15
switch = 25
```

## Output

```
==========================================
     CHIA PROFIT & ENERGY COST REPORT
==========================================

Date              11/12/2024
Wallet Address    xch1...
Energy [USD/kWh]  0.12 USD
Price XCH         25.00 USD
Chia Netspace     35.00 EiB
Reward/plot day   0.000021 XCH

REWARDS
Period     XCH      USD      equiv Plots  eff Size (TiB)
------------------------------------------------------
24 hours   0.125    $3.13    59           5.84
07 days    0.875    $21.88   59           5.84
30 days    3.750    $93.75   59           5.84

PROFIT LAST 24H
Reward : $3.13
Cost   : $1.20
===================
last24h  : $1.93
Weekly   : $13.51
Monthly  : $57.90
Yearly   : $704.45
```

## Requirements

- Python 3
- `colorama`
- `requests`

Install dependencies:
```bash
pip3 install colorama requests
```

## Data Sources

- Wallet transactions: xchscan.com API
- XCH price: CoinGecko API
- Netspace: xchscan.com API
- Energy: Tasmota smart plugs (optional)
