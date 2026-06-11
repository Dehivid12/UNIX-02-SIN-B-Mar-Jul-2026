# Dockerfile: A recipe for building the course image
# A Dockerfile is a text file that has instructions which Docker or Codespaces reads in order to build an image.
# An image is like a mold of a Linux system, always ready to use. Every time a Codespace is opened, a container is created from that mold.
# If the image were a house blueprint, the container would be the built house. Many houses can be built and destroyed without changing the blueprint.
# Every instruction creates a layer, and Docker saves those layers in the cache. The layers are stacked in order, so each one depends on the layers built before it.
# Docker reuses the layers that did not change, so the steps that rarely change go first to keep their cache and make rebuilds faster (Docker / containers — BHB Ch.3).

# FROM: The base image we build on
# We don't have to start from scratch, as we will start from the official Kali Linux image in its rolling version (continuously updated).
# Everything from now on is stacked on top of this base.
# We use Kali because it already comes with the security/pentesting tools the course needs (Kali + Docker lab — BHB Ch.3).

FROM kalilinux/kali-rolling:latest


# ENV defines variables that stay set for the whole image and that any program can read (environment variables — BHB Ch.1).
# DEBIAN_FRONTEND=noninteractive switches apt to a silent mode so it never stops the build to ask a question.
# LANG and LC_ALL fix the language and use UTF-8 encoding, which is what lets accents, ñ and other symbols print correctly.
# TERM=xterm-256color tells programs the terminal can show 256 colors, so tools like vim or htop render all the colors.
# The "\" at the end of each line sends the ENV instruction to the next line.

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=es_ES.UTF-8 \
    LC_ALL=es_ES.UTF-8 \
    TERM=xterm-256color


# Some packages ask configuration questions while installing. In an automated build there is nobody to answer, so it would hang forever. 
# This line pre-loads the answer to Wireshark's question (allow non-root packet capture? -> no) before the installation. 
# The pipe "|" sends the text from echo straight into debconf-set-selections as its input (pipes / standard input — BHB Ch.1).

RUN echo "wireshark-common wireshark-common/install-setuid boolean false" \
    | debconf-set-selections

# Build-time installation of every tool the course uses, done in a single RUN.
# "apt-get update" refreshes the package index, then "apt-get install" pulls the packages.
# -y skips the manual yes/no confirmation (there is no human during the build).
# --no-install-recommends keeps only the requested packages, not their extras (optional). 
# Doing it all in ONE RUN is important because each RUN becomes a separate cached layer. One big install is a single layer instead of dozens (smaller, faster image — BHB Ch.3).
# Each "&&" means "continue only if the previous command worked", and the trailing "\" lets one command go through several lines.

RUN apt-get update && apt-get install -y --no-install-recommends \
    \
    # Editors and an extra shell to work comfortably inside the container:
    neovim \
    vim \
    zsh \
    bash-completion \
    \
    # The text-processing core of the course — Perl plus the classic UNIX filters gawk/sed/grep
    # for searching and transforming text (grep / sed / awk — BHB Ch.2):
    perl \
    make \
    gawk \
    sed \
    grep \
    \
    # Everyday UNIX commands: coreutils (ls, cat, sort, cut...), findutils (find/xargs),
    # procps (ps/top/kill), plus less, tree and the JSON tool jq:
    coreutils \
    findutils \
    procps \
    less \
    tree \
    jq \
    \
    # Manual pages, re-added because Kali strips them by default and we need `man` as a reference:
    man-db \
    manpages \
    manpages-posix \
    \
    # Networking basics plus certificate/locale support for downloads and git:
    curl \
    wget \
    git \
    git-lfs \
    ca-certificates \
    locales \
    \
    # shellcheck, a linter that catches bugs in shell scripts before they run:
    shellcheck \
    \
    # Scanning tools to map hosts and ports — nmap and the high-speed masscan:
    nmap \
    masscan \
    \
    # Packet sniffers to inspect traffic from the terminal — tcpdump and tshark (CLI Wireshark):
    tcpdump \
    tshark \
    \
    # A mix of smaller network utilities (DNS, whois, routing, ping, etc.):
    netcat-traditional \
    socat \
    dnsutils \
    whois \
    traceroute \
    mtr-tiny \
    iproute2 \
    net-tools \
    iputils-ping \
    \
    # Anonymity stack around Tor: the tor client, torsocks/proxychains to route traffic through it,
    # and obfs4proxy to disguise that traffic:
    tor \
    torsocks \
    proxychains4 \
    obfs4proxy \
    \
    # httpie, a friendlier HTTP client than curl for learning requests:
    httpie \
    \
 # Enable the Spanish locale (this is block f):
 && sed -i 's/# es_ES.UTF-8/es_ES.UTF-8/' /etc/locale.gen \
 && locale-gen \
 \
 # Clean the package cache (this is block g):
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*


# Make bash the shell that the following RUN steps use, instead of the default /bin/sh 
# Later commands can rely on bash features (sh vs bash, BHB Ch.1).

SHELL ["/bin/bash", "-c"]


# Set the container's default folder. Codespaces mounts the repo under /workspaces
# WORKDIR there means new terminals open right where our project files are.

WORKDIR /workspaces

# Set git options for the whole image (system level), so they apply to every user. 
# safe.directory '*' stops the "dubious ownership" error when the mounted repo is owned by anyone aside fromr the root user. 
# init.defaultBranch main makes new repos start on "main".
# pull.rebase false keeps `git pull` as a merge. 
# git lfs install --system
# They wire up Git LFS so large-file repos can work everywhere. 

RUN git config --system --add safe.directory '*' \
 && git config --system init.defaultBranch main \
 && git config --system pull.rebase false \
 && git lfs install --system

# Write root's zsh startup file with a here-document. Everything between <<'EOF' and EOF is input to cat, which saves it into /root/.zshrc. 
# 'EOF' keeps the text literal (no variable expansion), so the prompt code stays intact (here-documents / redirection — BHB Ch.1).
# The PROMPT string gives the style to the terminal line

RUN cat > /root/.zshrc <<'EOF'
PROMPT='%F{cyan}[Dehivid Salgado]%f %F{yellow}%1~%f %(?.%F{green}✓.%F{red}✗ %?)%f %# '
EOF

# ----------------------------------------------------------------------------
# CMD: the command that runs by default when the container STARTS (unlike RUN, which runs at
# build time). Here it launches zsh as the default shell. Codespaces replaces it with its own
# integrated terminal, but defining it keeps the image usable with plain Docker too (BHB Ch.3).
# ----------------------------------------------------------------------------
CMD ["/bin/zsh"]