#!/usr/bin/env bash

function convert0(){
  file="${1}"

  html="${file}".html;
  pdf="${file}".pdf;

  # depends=(chromium cmark-gfm)  # 'chromium' is e.g. provided by the package 'ungoogled-chromium'

  # Convert
  cmark-gfm "${file}" --to html --unsafe > "${html}"
  chromium --headless --disable-gpu --print-to-pdf="${pdf}" file://"${html}"

  # Cleanup
  rm "${html}"
}

function convert1(){
  md="${1}"
  out="${md}".pdf

  sudo pacman -S --needed pandoc
  # kpathsea requires mktexfmt which is provided by texlive-core
  sudo pacman -S --needed texlive-core

  # Does not support images with relative paths
  pandoc "${md}" -o "${out}" \
    --from=gfm \
    --table-of-contents \
    --pdf-engine=xelatex \
    --highlight-style=monochrome \
    --number-sections \
    -V 'fontsize: 12pt' \
    -V 'papersize: A4' \
    -V 'urlcolor: blue' \
    -V 'date: \today{}' \
    -V 'documentclass:article' \
    -V 'geometry:margin=1.5cm'
}

function convert2(){
  md="${1}"

  # * https://www.npmjs.com/package/markdown-pdf
  # * https://www.npmjs.com/package/remarkable
  # * https://www.npmjs.com/package/markdown-toc
  #
  # > By default, remarkable is configured to be similar to GFM,
  # > but with HTML disabled. This is easy to change if you prefer
  # > different settings.

  sudo pacman -S --needed nodejs-markdown-pdf
  sudo pacman -S --needed nodejs-markdown-toc  # optional for TOC

  # Optional: Insert TOC
  add-toc "${md}"
  md="${md}".TOC

  # Supports relative image paths and HTML images
  markdown-pdf \
    --paper-format=A4 \
    --paper-orientation=portrait \
    --paper-border=15mm \
    --remarkable-options='{ "html": "false" }' \
    "${md}"
}

function add-toc(){
  md="${1}"
  out="${1}".TOC

  # If there is a TOC anchor, the TOC can be inserted in place.
  # This is a workaround if no such anchor is present.

  head --lines 1 "${md}" > "${out}"
  printf '\n\n**Table of Contents**\n\n' >> "${out}"
  markdown-toc "${md}" >> "${out}"
  printf '\n\n---\n\n' >> "${out}"
  tail --lines +2 "${md}" >> "${out}"
}
