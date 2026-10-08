#!/bin/sh
# Installs the latest braney, or upgrades it in place:
#   curl -fsSL https://raw.githubusercontent.com/victormga/braney/main/scripts/install.sh | sh
set -eu

REPO="victormga/braney"
INSTALL_DIR="$HOME/.local/bin"

fail() {
	echo "braney: $1" >&2
	exit 1
}

# Called on the last line only, so a download cut short runs nothing.
main() {
	case "$(uname -s)" in
	Linux) os=linux ;;
	Darwin) os=darwin ;;
	*) fail "no build for $(uname -s), see https://github.com/$REPO/releases" ;;
	esac

	case "$(uname -m)" in
	x86_64 | amd64) arch=amd64 ;;
	aarch64 | arm64) arch=arm64 ;;
	*) fail "no build for $(uname -m), see https://github.com/$REPO/releases" ;;
	esac

	# A terminal under Rosetta reports x86_64 on Apple Silicon.
	if [ "$os" = darwin ] && [ "$arch" = amd64 ] && [ "$(sysctl -n hw.optional.arm64 2>/dev/null)" = 1 ]; then
		arch=arm64
	fi

	asset="braney_${os}_${arch}.tar.gz"
	url="https://github.com/$REPO/releases/latest/download"

	tmp=$(mktemp -d)
	trap 'rm -rf "$tmp"' EXIT

	echo "Downloading $asset"
	curl -fsSL "$url/$asset" -o "$tmp/$asset"
	curl -fsSL "$url/checksums.txt" -o "$tmp/checksums.txt"

	expected=$(awk -v name="$asset" '$2 == name { print $1 }' "$tmp/checksums.txt")
	if command -v sha256sum >/dev/null 2>&1; then
		actual=$(sha256sum "$tmp/$asset" | cut -d ' ' -f 1)
	else
		actual=$(shasum -a 256 "$tmp/$asset" | cut -d ' ' -f 1)
	fi
	[ -n "$expected" ] && [ "$expected" = "$actual" ] || fail "checksum mismatch for $asset"

	tar -xzf "$tmp/$asset" -C "$tmp" braney

	# Renamed into place: writing over a braney that is running fails on Linux.
	mkdir -p "$INSTALL_DIR"
	cp "$tmp/braney" "$INSTALL_DIR/.braney.install"
	chmod 755 "$INSTALL_DIR/.braney.install"
	mv -f "$INSTALL_DIR/.braney.install" "$INSTALL_DIR/braney"

	echo "Installed braney to $INSTALL_DIR/braney"

	case ":$PATH:" in
	*":$INSTALL_DIR:"*)
		echo "Run braney in your project folder to start."
		;;
	*)
		echo
		echo "$INSTALL_DIR is not on your PATH yet. To add it:"
		case "$(basename "${SHELL:-sh}")" in
		zsh) echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.zshrc" ;;
		bash) echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc" ;;
		fish) echo "  fish_add_path ~/.local/bin" ;;
		*) echo "  add $INSTALL_DIR to PATH in your shell's startup file" ;;
		esac
		echo "Then open a new terminal and run braney in your project folder."
		;;
	esac
}

main
