# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Wprowadzenie do narzedzi bioinformatycznych
# Maszyna wirtualna do zajec, rok akademicki 2026/2027
# dr inz. Bartosz Kozak, Uniwersytet Przyrodniczy we Wroclawiu
#
# Uruchomienie:   vagrant up
# Wejscie:        vagrant ssh
# Zatrzymanie:    vagrant halt
# Usuniecie:      vagrant destroy

Vagrant.configure("2") do |config|

  # Ubuntu 24.04 LTS. Box bento ma warianty dla VirtualBox, Parallels i VMware.
  config.vm.box = "bento/ubuntu-24.04"
  config.vm.hostname = "wnb2026"

  # --- Zasoby maszyny ---------------------------------------------------
  # 2 rdzenie i 4 GB pamieci wystarcza do wszystkich zajec.
  # Ciezkie obliczenia (BLAST na calym genomie) wykonujemy na serwerze BEM2.

  config.vm.provider "virtualbox" do |vb|
    vb.name   = "wnb2026"
    vb.cpus   = 2
    vb.memory = 4096
    # Bez interfejsu graficznego, pracujemy w terminalu
    vb.gui    = false
  end

  # Wariant dla komputerow Apple z procesorem serii M
  config.vm.provider "parallels" do |prl|
    prl.name   = "wnb2026"
    prl.cpus   = 2
    prl.memory = 4096
  end

  config.vm.provider "vmware_desktop" do |vmw|
    vmw.cpus   = 2
    vmw.memory = 4096
  end

  # --- Katalog wspoldzielony --------------------------------------------
  # Katalog z Vagrantfile jest widoczny w maszynie jako ~/wnb2026.
  # Dzieki temu pliki mozna edytowac ulubionym edytorem na wlasnym
  # komputerze, a uruchamiac w maszynie wirtualnej.
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.synced_folder ".", "/home/vagrant/wnb2026"

  # --- Instalacja oprogramowania ----------------------------------------
  config.vm.provision "shell", path: "provision.sh"

  config.vm.post_up_message = <<~KOMUNIKAT

    ==========================================================
     Maszyna wirtualna wnb2026 jest gotowa.

       vagrant ssh     wejscie do maszyny
       vagrant halt    zatrzymanie
       vagrant up      ponowne uruchomienie

     Katalog ~/wnb2026 w maszynie to ten sam katalog,
     w ktorym lezy plik Vagrantfile na Twoim komputerze.
    ==========================================================

  KOMUNIKAT
end
