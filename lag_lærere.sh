#!/bin/bash

lererfil="lærere.csv"

tail -n +2 "$lererfil" | while IFS="," read -r klasse lerer fag; do
  #Lager lerere
  lerer=$(echo "$lerer" | tr -d '\r')
  brukernavn=$(echo "$lerer" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
  echo "Lager bruker med brukernavn: $brukernavn, klasse: $klasse, lerer: $lerer, fag: $fag"
  useradd -c "$lerer" "$brukernavn"
  echo "$brukernavn:Passord123" | sudo chpasswd
done