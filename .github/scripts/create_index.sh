#!/bin/sh

set -e

repo_root="${GITHUB_WORKSPACE}/${BRANCH_NAME}"
build_core="${BUILD_CORE:-false}"
odd_dir="${repo_root}/tei/odd"
doc_dir="${repo_root}/tei/documentation"
rng_dir="${repo_root}/tei/rng"
readme_path="${repo_root}/tei/README.md"

section_file="$(mktemp)"

echo "## Available Schemata" >"$section_file"
echo >>"$section_file"

found_items=false

list_odds() {
  if [ "$build_core" = "true" ] && [ -f "${odd_dir}/consolidated-schema.odd" ]; then
    printf '%s\n' "${odd_dir}/consolidated-schema.odd"
  fi
  find "$odd_dir" -maxdepth 1 -type f -name '*.odd' ! -name 'consolidated-schema.odd' | sort
}

for odd_file in $(list_odds); do
  [ -f "$odd_file" ] || continue
  base="$(basename "$odd_file" .odd)"
  doc_path="${doc_dir}/${base}.html"
  rng_path="${rng_dir}/${base}.rng"
  if [ ! -f "$doc_path" ] && [ ! -f "$rng_path" ]; then
    continue
  fi
  found_items=true
  {
    printf '### %s\n' "$base"
    if [ -f "$doc_path" ]; then
      printf -- '- [Read the %s documentation](https://cambridge-collection.github.io/epsilon-submission-toolbox/tei/documentation/%s.html)\n' "$base" "$base"
    fi
    if [ -f "$rng_path" ]; then
      printf -- '- Use the Epsilon %s schema in your TEI letter transcriptions:\n\n' "$base"
      printf -- '  ```xml\n'
      printf -- '  <?xml-model href="https://raw.githubusercontent.com/cambridge-collection/epsilon-submission-toolbox/main/tei/rng/%s.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>\n' "$base"
      printf -- '  <?xml-model href="https://raw.githubusercontent.com/cambridge-collection/epsilon-submission-toolbox/main/tei/rng/%s.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>\n' "$base"
      printf -- '  ```\n'
    fi
    printf -- '- Validate your TEI files against this schema before submission.\n\n'
  } >>"$section_file"
done

if [ "$found_items" = false ]; then
  echo "- _No generated schemata yet. Run the build workflow to populate this list._" >>"$section_file"
  echo >>"$section_file"
fi

new_readme="$(mktemp)"

if [ -f "$readme_path" ] && grep -q '^## Available Schemata' "$readme_path"; then
  awk 'BEGIN{marker="## Available Schemata";found=0}
       index($0, marker)==1 {found=1; exit}
       {print}' "$readme_path" >"$new_readme"
else
  [ -f "$readme_path" ] && cat "$readme_path" >"$new_readme"
fi

cat "$section_file" >>"$new_readme"

mv "$new_readme" "$readme_path"
rm "$section_file"
