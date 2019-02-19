#!/usr/bin/env bash
set -e

source=$1

if [ -z "$1" ]
then
    echo "Pass the path to the openapi.yaml file as a parameter to this script"
    exit -1
fi
dir=$(  pwd -P )

# Generate docs in AsciiDoc format > `tmp/index.adoc`.
java -jar swagger2markup-cli-1.3.3.jar convert \
    -i ${source} \
    -f ${dir}/openapi \
#    -c ${dir}/config.properties \
    >$(tty)

echo "Removing contact information"
./contact_removal openapi.adoc

echo "Adding Medidata flavored front page"
./add_front_page openapi.adoc

echo "Rendering beautifully into PDF...🧚 ✨"
export PATH=$PATH:${dir}/gems/bin
export GEM_PATH=$GEM_PATH:${dir}/gems
# Convert AsciiDoc to PDF (output to stdout).
asciidoctor-pdf -a pdf-style=theme.yml --out-file=openapi.pdf openapi.adoc

echo "Your beautiful file available as openapi.pdf in this directory 👍"
