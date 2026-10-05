# Wprowadzenie do narzedzi bioinformatycznych
# Wariant zapasowy srodowiska zajec, oparty na kontenerze.
#
# Przeznaczenie: komputery, na ktorych nie da sie uruchomic maszyny
# wirtualnej, w szczegolnosci komputery Apple z procesorem serii M
# oraz stanowiska bez uprawnien administratora do instalacji VirtualBox.
#
# Budowa:       docker build -t wnb2026 .
# Uruchomienie z katalogu maszyna_wirtualna/ (nie z docker/):
#   docker run -it --rm -v "$PWD":/home/student/wnb2026 -w /home/student/wnb2026 wnb2026

FROM ubuntu:24.04

LABEL opis="Srodowisko zajec: Wprowadzenie do narzedzi bioinformatycznych"
LABEL rok="2026/2027"

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV TZ=Europe/Warsaw

# Te same narzedzia co w maszynie wirtualnej
RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends \
        git curl wget nano vim less tree unzip bzip2 file \
        gawk sed grep coreutils diffutils \
        openssh-client ca-certificates build-essential \
        python3 python3-pip sudo \
    && update-alternatives --set awk /usr/bin/gawk \
    && rm -rf /var/lib/apt/lists/*

# Uzytkownik bez uprawnien administratora.
# Praca na koncie root zaburzylaby cwiczenia o uprawnieniach plikow.
RUN useradd -m -s /bin/bash student \
    && echo "student ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/student

# Miniforge, czyli conda i mamba
RUN ARCH="$(uname -m)" \
    && wget -q -O /tmp/miniforge.sh \
       "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-${ARCH}.sh" \
    && bash /tmp/miniforge.sh -b -p /opt/miniforge \
    && rm -f /tmp/miniforge.sh \
    && chown -R student:student /opt/miniforge

# conda init zapisuje sie do .bashrc, ktory w Ubuntu nie wykonuje sie
# w powlokach nieinteraktywnych. Dodatkowy wpis w /etc/profile.d sprawia,
# ze conda i mamba dzialaja rowniez w skryptach.
RUN printf '%s\n' \
      'export MAMBA_ROOT_PREFIX=/opt/miniforge' \
      '. /opt/miniforge/etc/profile.d/conda.sh' \
      '[ -f /opt/miniforge/etc/profile.d/mamba.sh ] && . /opt/miniforge/etc/profile.d/mamba.sh' \
      > /etc/profile.d/10-conda.sh

USER student
WORKDIR /home/student/wnb2026

RUN /opt/miniforge/bin/conda init bash \
    && printf '%s\n' \
        "" \
        "# --- Ustawienia dodane przez konfiguracje zajec ---" \
        "alias ll='ls -alF'" \
        "alias la='ls -A'" \
        "alias ..='cd ..'" \
        "export EDITOR=nano" \
        >> /home/student/.bashrc

CMD ["/bin/bash", "-l"]
