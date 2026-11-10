#!/usr/bin/env bash

config="${XDG_CONFIG_HOME:-$HOME/.config}/lla/config.toml"

if [ -f "$config" ]; then
    exit 0
fi

echo "lla: no config found. Run 'lla init' to start the setup wizard."

add_hint() {
    grep -qF '# >>> lla-feature >>>' "$1" 2>/dev/null && return
    cat >> "$1" <<'EOF'

# >>> lla-feature >>>
if [[ $- == *i* ]] && [ ! -f "${XDG_CONFIG_HOME:-$HOME/.config}/lla/config.toml" ]; then
    echo "lla: no config found. Run 'lla init' to start the setup wizard."
fi
# <<< lla-feature <<<
EOF
}

add_hint "$HOME/.bashrc"
[ -f "$HOME/.zshrc" ] && add_hint "$HOME/.zshrc"

exit 0
