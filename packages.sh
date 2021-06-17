#!/usr/bin/env bash
mkdir packages_dir

radical='testexo'
for i in {1..4}; do
  if [[  -f "packages_dir/${radical}${i}.deb" ]] && continue
  mkdir -p ${radical}${i}/DEBIAN/
  cat > ${radical}${i}/DEBIAN/control <<EOF
Package: ${radical}${i}
Version: 1.6
Section: custom
Priority: optional
Architecture: all
Essential: no
Installed-Size: 1024
Maintainer: antony.turpin@cerbair.com
Description: Learning package
EOF

dpkg-deb --build ${radical}${i}
mv ${radical}${i}.deb packages_dir/
rm -rf ${radical}${i}/
done
