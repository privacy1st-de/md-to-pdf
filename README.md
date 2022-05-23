# md-to-pdf

To be able to convert one or more Markdown (`.md`) files to pdf, save [md-to-pdf](md-to-pdf) in `"$HOME"/.local/share/nautilus/scripts/md-to-pdf` and make it executable.

Screenshot of the context menu in Nautilus (GNOME files):

![](./Nautilus-context-menu.png)

As an example, one can have a look at this README file converted to pdf: [README.md.pdf](./README.md.pdf)

## The conversion process

At first the Markdown is converted to HTML with `cmark-gfm`. Then the HTML file is modified so that large
images fit on the PDF. Finally `wkhtmltopdf` converts HTML to pdf.

## Alternatives conversion methods

See [alternatives.sh](alternatives.sh).
