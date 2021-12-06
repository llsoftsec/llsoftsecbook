# First copy build directory to to_publish directory
cp -R build to_publish

# Now add basic visitor counter to index.html, so that we can have a basic feel
# for how often the page is watched.
sed -i -e 's|</head>|<script data-goatcounter="https://llsoftsecbook.goatcounter.com/count" async src="//gc.zgo.at/count.js"></script></head>|' to_publish/index.html
