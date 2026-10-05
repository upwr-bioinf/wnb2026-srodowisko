# Środowisko zajęć — Wprowadzenie do narzędzi bioinformatycznych

Rok akademicki 2026/2027.

To repozytorium kursu na GitHubie zawiera konfigurację maszyny wirtualnej / kontenera.
Instrukcja uruchomienia jest w materiałach bloku 1 (`01_linux_i_git.md`, punkt B.1).

## Pobranie (bez Gita)

Na początku bloku 1 Git nie jest jeszcze wymagany. Wystarczy:

1. **Code → Download ZIP** na tej stronie,
2. rozpakować archiwum,
3. w katalogu z plikiem `Vagrantfile` wykonać `vagrant up`, potem `vagrant ssh`.

## Później, gdy znasz już Gita

```bash
git clone https://github.com/upwr-bioinf/wnb2026-srodowisko.git
cd wnb2026-srodowisko
vagrant up
vagrant ssh
```

Wariant Docker: katalog `docker/`.
