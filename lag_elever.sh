#!/bin/bash

elevfil="elever.csv"
fagfil="fag.csv"

tail -n +2 "$elevfil" | while IFS="," read -r linje klasse elev fritak; do
  # Lager elev
  elev=$(echo "$elev" | tr -d '\r')   # fjerner \r
  brukernavn=$(echo "$elev" | tr '[:upper:]' '[:lower:]' | tr 'Ø' 'o' | tr ' ' '_')
  echo "Lager bruker med brukernavn: $brukernavn, linje: $linje, klasse: $klasse, elev: $elev, fritak: $fritak" 
  useradd -c "$elev" "$brukernavn"
  echo "$brukernavn:Passord123" | sudo chpasswd   # fungerer på Ubuntu

  # Legger til grupper på eleven
  tail -n +2 "$fagfil" | while IFS="," read -r fag_linje fag; do
    fag_linje=$(echo "$fag_linje" | tr -d '\r')
    fag=$(echo "$fag" | tr -d '\r')

    if [ "$fag_linje" = "$linje" ]; then
      echo "  Legger $brukernavn til gruppe: $fag"
      sudo usermod -aG "$fag" "$brukernavn"
    fi
  done

  # Fjerner grupper eleven har fritak for
  if [ -n "$fritak" ]; then    # sjekk at fritak ikke er tomt
    echo "$fritak" | tr '+' '\n' | while read -r fritaksfag; do
      fritaksfag=$(echo "$fritaksfag" | tr -d '\r')
      echo "  Fjerner $brukernavn fra gruppe: $fritaksfag"
      sudo gpasswd -d "$brukernavn" "$fritaksfag"
    done
  fi

done
