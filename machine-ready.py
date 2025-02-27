#!/usr/bin/python3

from json import load
from sys import stdin
from os import getenv
from requests import post

callback_url = getenv("READY_CALLBACK_URL")
if callback_url is None:
    raise RuntimeError(
        "Must supply base URL via READY_CALLBACK_BASE_URL environment variable."
    )
callback_token = getenv("READY_CALLBACK_TOKEN")
if callback_token is None:
    raise RuntimeError(
        "Must supply token via READY_CALLBACK_TOKEN environment variable."
    )
pipeline_id = getenv("CI_PIPELINE_ID")

state = load(stdin)
response = post(
    f"{callback_url}",
    json={
        "pipeline_id": pipeline_id,
        "token": callback_token,
        "proxmox_id": state["values"]["outputs"]["proxmox_id"]["value"],
        "ssh_ip": state["values"]["outputs"]["ssh_ip"]["value"],
        "ssh_user": state["values"]["outputs"]["ssh_user"]["value"],
    },
    timeout=30,
)
if response.status_code not in (200, 201):
    raise RuntimeError(
        f"Ready callback returned status {response.status_code}. Expected 200 or 201."
    )
