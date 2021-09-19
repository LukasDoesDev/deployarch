import json
import subprocess

PACMAN_SYNC_DB_COMMAND = 'sudo pacman --noconfirm -Sy'
AUR_HELPER_COMMAND = 'paru --noconfirm -S {}'
PACMAN_COMMAND = 'sudo pacman --noconfirm -S {}'

def run_cmds(array):
    subprocess.run('\n'.join(array),shell=True, check=True,executable='/bin/bash')

with open('./config.json') as f:
    config = json.load(f)

packages_raw = config.get('packages', {})
setup_raw = config.get('setup', {})

pacman_packages = set()
aur_packages = set()
scripts = []

for package_raw in packages_raw:
    # TODO: select with maybe website? or fzf?
    if package_raw.get('name') not in ['', None, 'custom dmenu', 'custom dwm']:
        if package_raw.get('script'):
            scripts.append(package_raw.get('script', ['echo error']))
        pacman_packages.update(package_raw.get('pacman', []))
        aur_packages.update(package_raw.get('aur', []))

pacman_packages_str = ' '.join(pacman_packages)
aur_packages_str = ' '.join(aur_packages)

run_cmds([
    PACMAN_SYNC_DB_COMMAND, # Synchronize package database
    PACMAN_COMMAND.format(pacman_packages_str), # Install Pacman packages
    AUR_HELPER_COMMAND.format(aur_packages_str), # Install AUR packages
])

for script in scripts:
    run_cmds(script)

for package_name, cmds in setup_raw.items():
    if package_name in pacman_packages or package_name in aur_packages:
        run_cmds(cmds)
