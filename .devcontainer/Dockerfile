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

# ----------------------------------------------------------------------------
# RUN: run commands while the image is being built. Here we install all the course
# software in a single RUN.
#   apt-get update  -> refreshes the list of available packages
#   apt-get install -> downloads and installs the listed packages
#     -y                      -> answers "yes" automatically
#     --no-install-recommends -> installs only the essentials, not the suggested extras (saves space)
# Why one big RUN and not many small ones? Each RUN creates a new layer; fewer layers
# means a smaller, faster image (images/layers — BHB Ch.3).
# "&&" chains commands so the next runs only if the previous succeeded; if something fails
# the build stops with an error (better a clear error than a broken image).
# ----------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    \
    # === Text editors and shells (command interpreters) ===
    neovim \
    vim \
    zsh \
    bash-completion \
    \
    # === Text-processing power tools (used in Units 2, 3 and 4) ===
    # gawk, sed and grep are the main pattern-scanning and stream-editing tools (grep/sed/awk — BHB Ch.2).
    perl \
    make \
    gawk \
    sed \
    grep \
    \
    # === Basic UNIX utilities ===
    # coreutils brings cat, ls, head, tail, sort, cut, tr, etc.
    # findutils brings find and xargs.
    # procps brings ps, top, kill (process management).
    # less = pager to read long files.
    # tree = shows directories as a tree.
    # jq = processes JSON from the command line.
    coreutils \
    findutils \
    procps \
    less \
    tree \
    jq \
    \
    # === Manual pages (the `man` command) ===
    # The Kali base image ships without docs to save space. We reinstall them because
    # in the course "man bash" or "man grep" is a constant reference.
    man-db \
    manpages \
    manpages-posix \
    \
    # === Basic networking and download utilities ===
    curl \
    wget \
    git \
    git-lfs \
    ca-certificates \
    locales \
    \
    # === Linter (automatic error checker) for Bash scripts ===
    shellcheck \
    \
    # === Network recon and scanning ===
    # nmap = the most famous port scanner.
    # masscan = mass scanning of large IP ranges.
    nmap \
    masscan \
    \
    # === Network packet capture and analysis ===
    # tcpdump = classic terminal capturer.
    # tshark = terminal version of Wireshark.
    tcpdump \
    tshark \
    \
    # === Miscellaneous network utilities ===
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
    # === Anonymity: Tor and similar ===
    # tor = Tor network client.
    # torsocks = wrapper that routes any command through Tor.
    # proxychains4 = chains several proxies.
    # obfs4proxy = obfuscates Tor traffic to evade blocks.
    tor \
    torsocks \
    proxychains4 \
    obfs4proxy \
    \
    # === HTTP client more readable than curl, good for learning ===
    httpie \
    \
 # --- After installing, enable the Spanish locale ---
 # sed -i edits /etc/locale.gen in place, uncommenting the es_ES.UTF-8 line (removing its "#").
 # Then locale-gen compiles the language files (sed / stream editor — BHB Ch.2).
 && sed -i 's/# es_ES.UTF-8/es_ES.UTF-8/' /etc/locale.gen \
 && locale-gen \
 \
 # --- Final cleanup: shrink the image size ---
 # apt leaves cache files we no longer need after installing. Deleting them here, in the
 # SAME RUN, keeps the final layer smaller. In a later RUN they would still take up space
 # in the earlier layer.
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*


# ----------------------------------------------------------------------------
# SHELL: which interpreter the following RUN steps use.
# By default Docker uses /bin/sh (an older, more limited shell). We switch it to bash in case
# we add more instructions with modern syntax like arrays or [[ ]] (sh vs bash — BHB Ch.1).
# ----------------------------------------------------------------------------
SHELL ["/bin/bash", "-c"]


# ----------------------------------------------------------------------------
# WORKDIR: the working directory when entering the container.
# Codespaces always mounts the repo at /workspaces/<repo-name>. Setting /workspaces here makes
# terminals open near our course files.
# ----------------------------------------------------------------------------
WORKDIR /workspaces


# ----------------------------------------------------------------------------
# Git configuration for the container, applied system-wide (all users in the image):
# - safe.directory '*': trust any mounted repo (needed because /workspaces files have a
#   different UID than root inside the container).
# - init.defaultBranch main: new repos default to "main", avoiding the master/main warning.
# - pull.rebase false: `git pull` merges by default instead of rebasing.
# - git lfs install --system: register the Git LFS hooks globally so LFS repos just work.
# ----------------------------------------------------------------------------
RUN git config --system --add safe.directory '*' \
 && git config --system init.defaultBranch main \
 && git config --system pull.rebase false \
 && git lfs install --system


# ----------------------------------------------------------------------------
# This RUN writes root's zsh config using a here-document (cat > /root/.zshrc <<'EOF' ... EOF):
# every line up to EOF is sent as standard input into `cat`, which writes it into .zshrc.
# The quotes around 'EOF' disable variable expansion, so the prompt codes are stored literally
# (redirection / here-documents — BHB Ch.1).
# The PROMPT line defines the zsh prompt: name in cyan, current directory in yellow, and a
# green ✓ / red ✗ that shows the exit status of the last command.
# ----------------------------------------------------------------------------
RUN cat > /root/.zshrc <<'EOF'
PROMPT='%F{cyan}[Dehivid Salgado]%f %F{yellow}%1~%f %(?.%F{green}✓.%F{red}✗ %?)%f %# '
EOF

# ----------------------------------------------------------------------------
# CMD: the command that runs by default when the container STARTS (unlike RUN, which runs at
# build time). Here it launches zsh as the default shell. Codespaces replaces it with its own
# integrated terminal, but defining it keeps the image usable with plain Docker too (BHB Ch.3).
# ----------------------------------------------------------------------------
CMD ["/bin/zsh"]