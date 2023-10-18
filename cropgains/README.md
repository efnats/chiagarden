# MeadowGains: A Chia Profitability & Monitoring Solution

cropgains is a tool designed to help you monitor and report the profitability of your Chia mining farm. It calculates energy consumption, costs, and Chia rewards to provide you with a comprehensive understanding of your operation's net gains.

## Features
- Fetches the latest Chia XCH price.
- Reports rewards received over 24 hours, 7 days, and 30 days.
- Calculates energy consumption and costs based on Tasmota devices and user-defined power draw data.
- Displays a neatly formatted table with all the essential information.

## Getting Started

### Prerequisites
1. Python3.x installed
2. Necessary libraries (requests, colorama, etc.)

### Installation
1. Clone this repository:
   ```git clone [https://github.com/efnats/chiagarden.git]```
2. Navigate to the repository directory:
   ```cd chiagarden/cropgains```
3. Install the necessary libraries:
   ```pip install -r requirements.txt```

### Configuration
To correctly retrieve energy consumption details and calculate costs, you must configure the `cropgains.cfg` file. The configuration file has multiple sections:

1. **DEFAULT**:
    - `WALLET_ADDRESS`: Your Chia wallet address.
    - `ELECTRICITY_PRICE_USD`: Electricity price in USD per kWh.
2. **DEVICES_IP**: 
    - Define devices by their names and associated Tasmota IPs. E.g., `device_name = 192.168.x.x`.
3. **DEVICES_POWER_DRAW**: 
    - For devices without a Tasmota IP, define their names and power consumption in watts. E.g., `device_name = 150`.

When a device is defined in both sections, the script prefers to retrieve data from the IP. If it fails, the static power draw from DEVICES_POWER_DRAW will be used. Run the script:
```python3 cropgains.py```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](https://choosealicense.com/licenses/mit/)
