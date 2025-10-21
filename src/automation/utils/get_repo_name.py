import subprocess
import re
import sys

def get_repo_name():
    # Get the remote.origin.url from git config
    url = subprocess.check_output(
        ["git", "config", "--get", "remote.origin.url"],
        text=True
    ).strip()

    # Match organization and repo parts from SSH or HTTPS URLs
    match = re.search(r'[:/](?P<org>[^/]+)/(?P<repo>[^/.]+)(\.git)?$', url)
    if match:
        org = match.group('org')
        repo = match.group('repo')
        return f"{org}/{repo}"
    else:
        return None

if __name__ == "__main__":
    result = get_repo_name()
    if result:
        print(result)
    else:
        print("unknown/unknown")
        print("Could not parse git remote URL.", file=sys.stderr)
