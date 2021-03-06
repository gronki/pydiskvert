DVFLAGS="-no-bf"

date | tee "${1}.log"
cat "${1}.par" | dv-mag-rx $DVFLAGS -compton -o "${1}W" 2>&1 | tee -a "${1}.log"
cat "${1}.par" | dv-mag-rx $DVFLAGS -compton -post-corona -o "${1}Wp" 2>&1 | tee -a "${1}.log"
cat "${1}.par" | dv-mag-rx $DVFLAGS -corona  -o "${1}C" 2>&1 | tee -a "${1}.log"
