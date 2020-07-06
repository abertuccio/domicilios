
apt-get install osmium-tool
npm install -g osmtogeojson

osmium getid -r -t argentina-latest.osm.pbf r1767342 -o moron-boundary.osm

osmium extract -p moron-boundary.osm argentina-latest.osm.pbf -o moron.pbf

osmium tags-filter moron.pbf w/highway -o calles_moron.osm.pbf