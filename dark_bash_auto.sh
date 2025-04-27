#!/bin/bash

echo "🌐 Welcome to the Light/Dark Mode Website Generator!"

# ----------- User Input -----------
read -p "Use a background image? (y/n): " bg_image_choice

if [[ "$bg_image_choice" == "y" || "$bg_image_choice" == "Y" ]]; then
  read -p "Enter background image URL: " bg_image_url
fi

echo "Choose a font:"
echo "1) Verdana"
echo "2) Arial"
echo "3) Courier New"
echo "4) Times New Roman"
read -p "Select 1-4 (default: 1): " font_choice

case $font_choice in
  2) font="Arial, sans-serif" ;;
  3) font="'Courier New', monospace" ;;
  4) font="'Times New Roman', serif" ;;
  *) font="Verdana, sans-serif" ;;
esac

read -p "Site name (default: my_site): " site_name
site_name=${site_name:-my_site}

read -p "Home Page Header (default: Welcome!): " home_header
home_header=${home_header:-Welcome!}

read -p "Home Page Paragraph (default: Thanks for visiting!): " home_paragraph
home_paragraph=${home_paragraph:-Thanks for visiting!}

read -p "About Page Header (default: About Me): " about_header
about_header=${about_header:-About Me}

read -p "About Page Paragraph (default: This is the about page.): " about_paragraph
about_paragraph=${about_paragraph:-This is the about page.}

read -p "Contact Page Header (default: Contact Us): " contact_header
contact_header=${contact_header:-Contact Us}

read -p "Contact Page Paragraph (default: Email me at you@example.com): " contact_paragraph
contact_paragraph=${contact_paragraph:-Email me at you@example.com}

mkdir "$site_name"
cd "$site_name" || exit
# ------------------------------------

# ----------- Common CSS, JS -----------
generate_style_and_script() {
cat <<EOF
<style>
body {
  background-color: white;
  color: black;
  font-family: $font;
  text-align: center;
  padding: 50px;
  min-height: 100vh;
  margin: 0;
  transition: 0.5s;
$(if [[ "$bg_image_choice" == "y" || "$bg_image_choice" == "Y" ]]; then echo "background-image: url('$bg_image_url'); background-size: cover; background-position: center;"; fi)
}

body.dark {
  background-color: black;
  color: white;
}

nav {
  margin: 20px;
}

nav a {
  margin: 10px;
  text-decoration: none;
  color: inherit;
  font-weight: bold;
  font-size: 18px;
}

button {
  margin: 20px;
  padding: 10px 20px;
  font-size: 16px;
  cursor: pointer;
}
</style>

<script>
function toggleMode() {
  document.body.classList.toggle('dark');
}

function detectUserStuff() {
  let os = "Unknown OS";
  let browser = "Unknown Browser";
  const userAgent = navigator.userAgent;

  // Detect OS
  if (userAgent.indexOf("Win") != -1) os = "Windows";
  else if (userAgent.indexOf("Mac") != -1) os = "MacOS";
  else if (userAgent.indexOf("X11") != -1) os = "Unix";
  else if (userAgent.indexOf("Linux") != -1) os = "Linux";
  else if (userAgent.indexOf("Android") != -1) os = "Android";
  else if (/iPhone|iPad|iPod/.test(userAgent)) os = "iOS";

  // Detect Browser
  if (userAgent.indexOf("Firefox") != -1) browser = "Firefox";
  else if (userAgent.indexOf("Edg") != -1) browser = "Edge";
  else if (userAgent.indexOf("Chrome") != -1) browser = "Chrome";
  else if (userAgent.indexOf("Safari") != -1 && userAgent.indexOf("Chrome") == -1) browser = "Safari";

  document.getElementById("os-info").innerHTML = "Nice OS! You're running <b>" + os + "</b>.";
  document.getElementById("browser-info").innerHTML = "Great choice in browser! You're using <b>" + browser + "</b>.";
}

// Run it when page loads
window.onload = detectUserStuff;
</script>
EOF
}
# ------------------------------------

# ----------- Generate Pages -----------
create_page() {
  local filename=$1
  local title=$2
  local header=$3
  local paragraph=$4

  cat > "$filename" <<EOF
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>$title</title>
  $(generate_style_and_script)
</head>
<body>
  <nav>
    <a href="index.html">Home</a> |
    <a href="about.html">About</a> |
    <a href="contact.html">Contact</a>
  </nav>

  <button onclick="toggleMode()">🌙/☀️ Switch Mode</button>

  <p id="os-info"></p>
  <p id="browser-info"></p>

  <h1>$header</h1>
  <p>$paragraph</p>
</body>
</html>
EOF
}

# Create index.html, about.html, contact.html
create_page "index.html" "Home - $site_name" "$home_header" "$home_paragraph"
create_page "about.html" "About - $site_name" "$about_header" "$about_paragraph"
create_page "contact.html" "Contact - $site_name" "$contact_header" "$contact_paragraph"
# ----------------------------------------

echo "✅ Website created in ./$site_name/ with Light/Dark Mode and OS/Browser detection!"

# ----------- Open in Browser -----------
if command -v firefox >/dev/null 2>&1; then
  firefox "index.html" &
elif command -v xdg-open >/dev/null 2>&1; then
  xdg-open "index.html" &
else
  echo "⚠️ Could not detect a browser to open the website."
fi
# ----------------------------------------
