#!/bin/sh

set -e

IFS=$"
"

odd_path="$1"
rng_name="$(echo "$odd_path" | sed -E 's#\.[^.]*$##g')"
rng_name="$(basename "$rng_name")"

repo_root="${GITHUB_WORKSPACE}/${BRANCH_NAME}"
output_rng_dir="${repo_root}/tei/rng"
output_doc_dir="${repo_root}/tei/documentation"
output_compiled_dir="${repo_root}/tei/odd/compiled"

mkdir -p "$output_rng_dir" "$output_doc_dir" "$output_compiled_dir"

echo "INFO: Creating output for ${odd_path}"
echo "INFO: Generating RNG" && \
"$GITHUB_WORKSPACE/tei/bin/teitorng" "$odd_path" "${output_rng_dir}/${rng_name}.rng" && \
echo "INFO: DONE"

echo "INFO: Generating Compiled ODD" && \
java -DentityExpansionLimit=9000000 -jar "$GITHUB_WORKSPACE/saxon-he-12.1.jar" -xi:on \
-o:"${output_compiled_dir}/${rng_name}.compiled.odd" "$odd_path" "$GITHUB_WORKSPACE/tei/odds/odd2odd.xsl"  && \
echo "INFO: DONE"

echo "INFO: Generating online documentation" && \
java -DentityExpansionLimit=9000000 -jar "$GITHUB_WORKSPACE/saxon-he-12.1.jar" -xi:on \
-o:"${output_doc_dir}/${rng_name}.html" "${output_compiled_dir}/${rng_name}.compiled.odd" "${repo_root}/.github/lib/xslt/import-sample.xsl" && \
echo "INFO: Done"
