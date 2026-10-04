#!/usr/bin/env bash
#
# Konfiguracja maszyny wirtualnej do zajec.
# Skrypt uruchamia sie automatycznie przy pierwszym "vagrant up".
#
# Zasada: instalujemy wylacznie narzedzia systemowe.
# Srodowiska conda studenci tworza samodzielnie w bloku 2,
# bo jest to material do opanowania, a nie gotowiec.

set -euo pipefail

echo "=== [1/5] Aktualizacja listy pakietow ==="
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq

echo "=== [2/5] Instalacja narzedzi systemowych ==="
apt-get install -y -qq \
    git \
    curl \
    wget \
    nano \
    vim \
    less \
    tree \
    unzip \
    bzip2 \
    file \
    gawk \
    sed \
    grep \
    coreutils \
    diffutils \
    openssh-client \
    ca-certificates \
    build-essential \
    python3 \
    python3-pip \
    poppler-utils \
    > /dev/null

# gawk zamiast mawk. Domyslny awk w Ubuntu to mawk, ktory nie obsluguje
# czesci konstrukcji uzywanych na zajeciach, miedzy innymi funkcji
# definiowanych przez uzytkownika w dluzszych programach.
update-alternatives --set awk /usr/bin/gawk

echo "=== [3/5] Strefa czasowa i ustawienia regionalne ==="
timedatectl set-timezone Europe/Warsaw || true

# UWAGA: swiadomie NIE ustawiamy polskich ustawien regionalnych jako domyslnych.
# Polskie locale zmienia kolejnosc sortowania i separator dziesietny,
# co psuje polecenia typu "sort" i "awk" uzywane na zajeciach.
# Poprawnym nawykiem jest jawne LC_ALL=C tam, gdzie kolejnosc ma znaczenie.
cat > /etc/profile.d/99-wnb-locale.sh <<'LOCALE'
export LANG=C.UTF-8
export LC_ALL=C.UTF-8
LOCALE

echo "=== [4/5] Instalacja miniforge (conda i mamba) ==="
MINIFORGE=/opt/miniforge
if [ ! -d "$MINIFORGE" ]; then
    ARCH="$(uname -m)"
    URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-${ARCH}.sh"
    wget -q -O /tmp/miniforge.sh "$URL"
    bash /tmp/miniforge.sh -b -p "$MINIFORGE"
    rm -f /tmp/miniforge.sh
fi

# Udostepnienie conda i mamba uzytkownikowi vagrant.
# conda init zapisuje sie do .bashrc, ktory w Ubuntu nie wykonuje sie
# w powlokach nieinteraktywnych. Wpis w /etc/profile.d sprawia,
# ze conda i mamba dzialaja rowniez w skryptach.
sudo -u vagrant "$MINIFORGE/bin/conda" init bash > /dev/null
chown -R vagrant:vagrant "$MINIFORGE"

cat > /etc/profile.d/10-conda.sh <<CONDA
export MAMBA_ROOT_PREFIX=$MINIFORGE
. $MINIFORGE/etc/profile.d/conda.sh
[ -f $MINIFORGE/etc/profile.d/mamba.sh ] && . $MINIFORGE/etc/profile.d/mamba.sh
CONDA

echo "=== [5/5] Konfiguracja konta uzytkownika ==="
sudo -u vagrant mkdir -p /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh

# Kilka wygodnych ustawien, omawiane w bloku 1
cat >> /home/vagrant/.bashrc <<'BASHRC'

# --- Ustawienia dodane przez konfiguracje zajec ---
alias ll='ls -alF'
alias la='ls -A'
alias ..='cd ..'
export EDITOR=nano

# Katalog wspoldzielony z komputerem gospodarza
alias zajecia='cd ~/wnb2026'
BASHRC
chown vagrant:vagrant /home/vagrant/.bashrc

echo
echo "=== Gotowe. Zainstalowane wersje: ==="
git --version
awk --version | head -1
python3 --version
"$MINIFORGE/bin/mamba" --version | head -1
