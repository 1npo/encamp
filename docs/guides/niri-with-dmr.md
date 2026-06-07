# Setting up Niri with DankMaterialShell on Debian

Niri is a [scrollable tiling Weyland compositor](https://github.com/YaLTeR/niri).

It doesn't have a pre-built package for Debian. To build from source:

1. Install the following:
	- [rust](https://rustup.rs/)
	- [cargo-deb](https://crates.io/crates/cargo-deb)

2. Install the dependencies listed for Ubuntu in the "Building" section of Niri's [Getting Started Guide](https://yalter.github.io/niri/Getting-Started.html#building)
	- Copying and pasting the `apt install` command should work on Debian stable
	- If you're not on the stable version of Debian and you get an error when installing any of these dependencies, then perform a full-upgrade to Debian stable and try again

3. Clone the Niri repository and `cd` to it

4. Run `cargo deb --install`
	- Or `cargo deb` and then `dpkg -i target/debian/niri_<version>.deb`

5. Run `sudo apt install alacritty fuzzel`
	- These 2 dependencies are required when installing the `.deb` from step 4, but aren't listed on the guide

6. Install [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell)
	- `curl -fsSL https://install.danklinux.com | sh`

