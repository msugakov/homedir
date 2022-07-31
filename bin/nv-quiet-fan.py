#!/usr/bin/env python3

# Install via Desktop panel | Command so that it runs periodically and you see output in tray.

import subprocess
import logging
import sys
from enum import Enum
from pathlib import Path

logging.basicConfig(
    format="%(asctime)s: %(message)s", level=logging.DEBUG, stream=sys.stderr
)

OFF_TEMP = 50
WARM_TEMP = 60
HOT_TEMP = 75


class CoolingMode(Enum):
    SILENT = 0
    QUIET_FAN = 30
    FAST_FAN = 90


def get_nv_value(query):
    query_process = subprocess.run(
        ["nvidia-settings", "--terse", "--query", query],
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        encoding="utf-8",
    )

    return int(query_process.stdout)


def assign_nv_value(query):
    result = subprocess.run(
        ["nvidia-settings", "--assign", query],
        check=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        encoding="utf-8",
    )
    logging.debug(result.stdout)


def ensure_nv_value(query, value):
    current = get_nv_value(query)
    if current != value:
        assign_nv_value(f"{query}={value}")


mode_file = Path("~/.cache/nv-quiet-fan/mode.txt").expanduser()
mode_file.parent.mkdir(parents=True, exist_ok=True)


def read_mode():
    if mode_file.exists():
        return CoolingMode(int(mode_file.read_text()))
    return CoolingMode.SILENT


def write_mode(mode):
    mode_file.write_text(str(mode.value))


mode = read_mode()

logging.debug(f"Read mode: {mode}")

temperature = get_nv_value("[thermalsensor:0]/ThermalSensorReading")

if temperature > HOT_TEMP:
    # TODO: consider setting GPUFanControlState to 0 for automatic control by GPU and driver in this case
    mode = CoolingMode.FAST_FAN
elif temperature > WARM_TEMP:
    mode = CoolingMode.QUIET_FAN
elif temperature < OFF_TEMP:
    mode = CoolingMode.SILENT

logging.info(f"Temperature is: {temperature}°C. Desired target: {mode}={mode.value}%")

ensure_nv_value("[gpu:0]/GPUFanControlState", 1)
ensure_nv_value("[fan:0]/GPUTargetFanSpeed", mode.value)
ensure_nv_value("[fan:1]/GPUTargetFanSpeed", mode.value)

write_mode(mode)

fan0_speed = get_nv_value("[fan:0]/GPUCurrentFanSpeed")
fan1_speed = get_nv_value("[fan:1]/GPUCurrentFanSpeed")

print(f"🌡️{temperature}°C 💨{fan0_speed}+{fan1_speed}%")
