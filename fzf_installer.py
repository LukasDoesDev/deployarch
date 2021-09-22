#from __future__ import annotations
from fzf_installer_helpers import get_config, fzf, run_cmds, select_packages

config = get_config()

PACMAN_SYNC_DB_COMMAND = 'sudo pacman --noconfirm -Sy'
AUR_HELPER_COMMAND = 'paru --noconfirm -S --needed {}' # see https://github.com/Jguer/yay/issues/885
PACMAN_COMMAND = 'sudo pacman --noconfirm -S --needed {}'

packages_raw = config.get('packages', {})
packages_selected = select_packages(packages_raw)
setup_raw = config.get('setup', {})

pacman_packages = set()
aur_packages = set()
scripts = []
errs = []
outputs = {}

packagelists = []

for packagelist in packages_selected:
    print('123', packagelist.get('name', 'UNKNOWN NAME'))
    if packagelist.get('script'):
        scripts.append(packagelist.get('script', ['echo error']))
    pacman_packages.update(packagelist.get('pacman', []))
    aur_packages.update(packagelist.get('aur', []))
    packagelists.append(packagelist)

run_cmds([PACMAN_SYNC_DB_COMMAND])

for packagelist in packagelists:
    name = packagelist.get('name', 'UNKNOWN NAME')
    outputs[name] = {}
    pacman = packagelist.get('pacman', [])
    aur = packagelist.get('aur', [])
    try:
        if len(pacman) != 0:
            outputs[name]['pacman'] = run_cmds([PACMAN_COMMAND.format(' '.join(pacman))])
    except Exception as err:
        errs.append((name, 'pacman', pacman, err))
    try:
        if len(aur) != 0:
            outputs[name]['aur'] = run_cmds([AUR_HELPER_COMMAND.format(' '.join(aur))])
    except Exception as err:
        errs.append((name, 'aur', aur, err))

for script in scripts:
    run_cmds(script)

for package_name, cmds in setup_raw.items():
    if package_name in pacman_packages or package_name in aur_packages:
        run_cmds(cmds)

if len(errs) != 0:
    print ('The following errors happened while installing packages:')
    for err in errs:
        print (err, outputs[err[0]][err[1]])
