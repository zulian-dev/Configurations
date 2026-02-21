function haptic {
  curl -X POST "https://local.jmw.nz:41443/haptic/$1" -s -d '' >/dev/null
}

# create array with all haptic names

# "sharp_collision",
# "sharp_state_change",
# "knock",
# "damp_collision",
# "mad",
# "ringing",
# "subtle_collision",
# "completed",
# "jingle",
# "damp_state_change",
# "firework",
# "happy_alert",
# "wave",
# "angry_alert",
# "square"

haptics=(
  "sharp_collision"
  "sharp_state_change"
  "knock"
  "damp_collision"
  "mad"
  "ringing"
  "subtle_collision"
  "completed"
  "jingle"
  "damp_state_change"
  "firework"
  "happy_alert"
  "wave"
  "angry_alert"
  "square"
)

while true; do
  for haptic_name in "${haptics[@]}"; do
    echo "Triggering haptic: $haptic_name"
    haptic "$haptic_name"
    sleep 2
  done
done
