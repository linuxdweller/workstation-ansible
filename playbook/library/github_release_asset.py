#!/usr/bin/python

from io import BytesIO
from subprocess import CalledProcessError, run
from typing import Optional, Pattern
from tarfile import TarFile
from gzip import GzipFile
from pathlib import Path
import re

from ansible.module_utils.basic import AnsibleModule
import requests


def check_version(version_command: list[str], expected_version: str) -> bool:
    try:
        command_result = run(
            version_command, capture_output=True, text=True, check=True
        )
        # Strip leading v often included in tags, but not in version outputs.
        return expected_version.lstrip("v") in command_result.stdout
    except CalledProcessError:
        return False
    except FileNotFoundError:
        return False


def is_expected_version(executable_name: str, expected_version: str) -> bool:
    return (
        check_version([executable_name, "--version"], expected_version)
        or check_version([executable_name, "-v"], expected_version)
        or check_version([executable_name, "-V"], expected_version)
        or check_version([executable_name, "version"], expected_version)
    )


def fetch_release(repository: str, version: Optional[str] = None):
    release_url = f"https://api.github.com/repos/{repository}/releases/"
    if version:
        release_url += f"tags/{version}"
    else:
        release_url += "latest"
    release_response = requests.get(release_url, timeout=30)
    if release_response.status_code != 200:
        raise RuntimeError(
            f"Request to '{release_url}' failed with status {release_response.status_code}"
        )
    release_data = release_response.json()
    assets = [
        {"name": asset["name"], "url": asset["browser_download_url"]}
        for asset in release_data["assets"]
    ]
    return release_data["tag_name"], assets


def matches_all_keywords(name: str, keywords: list[Pattern[str]]) -> bool:
    return all(keyword.search(name) for keyword in keywords)


def filter_assets_by_keywords(assets: list[dict], keywords: list[str]) -> list[dict]:
    keyword_patterns = [re.compile(pattern) for pattern in keywords]
    return [
        asset
        for asset in assets
        if matches_all_keywords(asset["name"], keyword_patterns)
    ]


class ArchiveExtractionError(Exception):
    pass


def fetch_and_extract(url: str, executable_name: str):
    asset_response = requests.get(url, timeout=120)
    print(asset_response.status_code)
    with GzipFile(fileobj=BytesIO(asset_response.content)) as asset_archive:
        with TarFile(fileobj=asset_archive) as asset:
            executables = [
                file
                for file in asset.getmembers()
                if file.mode & 0b0001000000 == 0b0001000000
            ]
            if len(executables) != 1:
                raise ArchiveExtractionError()
            executable = asset.extractfile(executables[0])
            executable_path = Path("/usr/local/bin") / executable_name
            if executable:
                with executable_path.open("wb") as executable_file:
                    executable_file.write(executable.read())
                executable_path.chmod(0o755)


def remove_executable(executable_name: str) -> bool:
    executable_path = Path("/usr/local/bin") / executable_name
    try:
        executable_path.unlink()
        return True
    except FileNotFoundError:
        return False


def is_executable_present(executable_name: str) -> bool:
    executable_path = Path("/usr/local/bin") / executable_name
    return executable_path.exists()


def run_module():
    module_args = {
        "repo": {"type": str, "required": True},
        "release": {"type": str, "default": "latest"},
        "executable_name": {"type": str},
        "asset_pattern": {"type": str, "required": True},
        "state": {
            "type": str,
            "choices": ["present", "absent"],
            "default": "present",
        },
    }

    result = {"changed": False, "original_message": "", "message": ""}

    module = AnsibleModule(argument_spec=module_args, supports_check_mode=True)
    repo = module.params["repo"]
    release = module.params["release"]
    executable_name = module.params["executable_name"]
    asset_pattern = module.params["asset_pattern"]
    state = module.params["state"]

    if executable_name is None:
        executable_name = re.sub(r"[\w\d\-]*/", "", repo)

    if release == "latest":
        release = None

    if state == "absent":
        if module.check_mode:
            if is_executable_present(executable_name):
                result["changed"] = True
            module.exit_json(**result)
        if remove_executable(executable_name):
            result["changed"] = True
        module.exit_json(**result)

    # State is present.
    release_assets = []
    if release is None:
        release, release_assets = fetch_release(repo)
    if is_expected_version(executable_name, release):
        module.exit_json(**result)
    if len(release_assets) == 0:
        _, release_assets = fetch_release(repo, release)
    release_assets = filter_assets_by_keywords(release_assets, [asset_pattern])
    if len(release_assets) != 1:
        module.fail_json(msg="asset_pattern should match a single asset.", **result)
    if not module.check_mode:
        try:
            fetch_and_extract(release_assets[0]["url"], executable_name)
        except ArchiveExtractionError:
            module.fail_json(msg="failed extracting archive.", **result)
    result["changed"] = True
    module.exit_json(**result)


if __name__ == "__main__":
    run_module()
