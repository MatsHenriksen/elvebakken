fil="fag.csv"

tail -n +2 "$fil" | while IFS="," read -r linje fag; do
  fag=$(echo "$fag" | tr -d '\r')   # ← fjerner \r
  echo "linje: $linje, fag: $fag"
  groupadd "$fag"
done
