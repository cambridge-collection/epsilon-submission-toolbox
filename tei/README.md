---
title: TEI Submission Resources
layout: default
---

# TEI Submission Resources

- Create a directory for your collection at the root level of the submission toolkit and create a `letters` directory for your transcriptions.
- Transcribe each letter as a separate file according to the [letters documentation](https://cambridge-collection.github.io/epsilon-submission-toolbox/tei/documentation/letters.html). Create this file by duplicating the `tei/templates/letter-template.xml`.
- Make sure that the letter filenames match their unique letter id number (coding in `TEI`'s `xml:id`).


## Available Schemata

### letters
- [Read the letters documentation](https://cambridge-collection.github.io/epsilon-submission-toolbox/tei/documentation/letters.html)
- Use the Epsilon letters schema in your TEI letter transcriptions:

  ```xml
  <?xml-model href="https://raw.githubusercontent.com/cambridge-collection/epsilon-submission-toolbox/main/tei/rng/letters.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
  <?xml-model href="https://raw.githubusercontent.com/cambridge-collection/epsilon-submission-toolbox/main/tei/rng/letters.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
  ```
- Validate your TEI files against this schema before submission.

