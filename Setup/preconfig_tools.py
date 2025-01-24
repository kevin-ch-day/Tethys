import os
import subprocess

def check_and_install(package, install_command):
    """Checks if a tool is installed; if not, attempts to install it."""
    print(f"Checking {package}...")
    result = subprocess.run(["which", package], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if result.returncode != 0:
        print(f"{package} is not installed. Installing...")
        try:
            subprocess.run(install_command, shell=True, check=True)
            print(f"{package} installed successfully!")
        except subprocess.CalledProcessError:
            print(f"Failed to install {package}. Please check manually.")
    else:
        print(f"{package} is already installed.")


def verify_tool_configurations():
    """Ensure tools are preconfigured and ready."""
    tools = [
        {"name": "nmap", "install": "sudo apt-get install -y nmap"},
        {"name": "burpsuite", "install": "sudo apt-get install -y burpsuite"},
        {"name": "msfconsole", "install": "curl https://raw.githubusercontent.com/rapid7/metasploit-framework/master/msfinstall | bash"},
        {"name": "sqlmap", "install": "sudo apt-get install -y sqlmap"},
        {"name": "gobuster", "install": "sudo apt-get install -y gobuster"},
        {"name": "hydra", "install": "sudo apt-get install -y hydra"},
        {"name": "bloodhound", "install": "sudo apt-get install -y bloodhound"},
        {"name": "proxychains", "install": "sudo apt-get install -y proxychains"},
        {"name": "wireshark", "install": "sudo apt-get install -y wireshark"},
        {"name": "masscan", "install": "sudo apt-get install -y masscan"},
        {"name": "john", "install": "sudo apt-get install -y john"},
        {"name": "hashcat", "install": "sudo apt-get install -y hashcat"}
    ]

    print("Starting tool verification...")
    for tool in tools:
        check_and_install(tool["name"], tool["install"])


def verify_essential_directories():
    """Ensures critical directories exist for tool usage."""
    directories = [
        "~/wordlists",
        "~/tools",
        "~/payloads",
        "~/scripts",
        "~/reports",
        "~/logs"
    ]

    print("Verifying essential directories...")
    for directory in directories:
        expanded_dir = os.path.expanduser(directory)
        if not os.path.exists(expanded_dir):
            print(f"Directory {directory} not found. Creating it...")
            os.makedirs(expanded_dir)
            print(f"Created {directory}.")
        else:
            print(f"Directory {directory} already exists.")


def update_system():
    """Ensures the system is up-to-date."""
    print("Updating system packages...")
    try:
        subprocess.run("sudo apt-get update -y && sudo apt-get upgrade -y", shell=True, check=True)
        print("System packages updated successfully.")
    except subprocess.CalledProcessError:
        print("Failed to update system packages. Please check manually.")


def configure_bashrc_aliases():
    """Adds useful aliases to .bashrc for quick access to tools."""
    bashrc_path = os.path.expanduser("~/.bashrc")
    aliases = [
        "alias ll='ls -lah'",
        "alias nmap_scan='nmap -A -T4'",
        "alias gobuster_scan='gobuster dir -u http://example.com -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt'",
        "alias msfconsole='msfconsole -q'"
    ]

    print("Configuring .bashrc aliases...")
    try:
        with open(bashrc_path, "a") as bashrc:
            for alias in aliases:
                bashrc.write(f"\n{alias}")
        subprocess.run("source ~/.bashrc", shell=True, check=True)
        print("Aliases added successfully.")
    except Exception as e:
        print(f"Failed to configure .bashrc aliases: {e}")


def main():
    print("\n======== Red Team Tool Preconfiguration Script ========")
    update_system()
    verify_tool_configurations()
    verify_essential_directories()
    configure_bashrc_aliases()
    print("\nAll tools verified, preconfigured, and ready for action!")

if __name__ == "__main__":
    main()
