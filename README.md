# 🐠 Vispasseerbaarheid Getijdestuw Dender

## 📝 Beschrijving
Dit projectrepository bevat de resultaten, analyses en implementatievoorstellen voortkomend uit een **verkennende deskstudie** naar de **stroomopwaartse vispasseerbaarheid** van het getijdestuw-sluiscomplex op de Dender in Dendermonde.

De studie, uitgevoerd door het **Instituut voor Natuur- en Bosonderzoek (INBO)** in opdracht van **De Vlaamse Waterweg nv (DVW)**, evalueert de mate waarin het huidige operationele beheer van de stuw de migratie van vissoorten vanuit de Zeeschelde naar de Dender toelaat of belemmert, wat cruciaal is voor het herstel van de ecologische connectiviteit in het Vlaamse waterwegennetwerk.

Het herstellen van de vrije vismigratie op de Dender is essentieel voor zowel **diadrome** (migratie tussen zee en zoetwater) als **potamodrome** (migratie binnen zoetwater) vissoorten.

---

## 🎯 Doelstelling
De hoofddoelstelling van deze deskstudie is het evalueren van de **stroomopwaartse vispasseerbaarheid** van de getijdestuw onder het huidige beheer.

De bevindingen dienen als eerste stap richting:
* Mogelijke toekomstige **optimalisaties in het stuwbeheer** om de ecologische connectiviteit te herstellen of te verbeteren.
* Het identificeren van **mitigerende of beheerstechnische maatregelen** om de vismigratie te verbeteren.
* Een **voorstel voor vervolgonderzoek** (zoals telemetrie en hydraulische modellering) om tot duidelijk afgelijnde beheersvoorstellen te komen.

---

## 🔑 Belangrijkste Bevindingen over Vispassage
Onder de huidige omstandigheden is **stroomopwaartse visbeweging mogelijk**, zij het voor een beperkt deel van de tijd.

### Passeerbaarheidstijden (t.o.v. de gehele studieperiode)

| Route | Passeerbaarheid (Gehele Periode) |
| :--- | :--- |
| **Onder de stuw** | **8.6%** van de tijd |
| **Over de stuw** | **7.0%** van de tijd |

### Cruciale Drempels
* **Vispassage onder de stuw is gunstiger** dan over de stuw.
* **Stroomopwaartse beweging onder de stuw bij gehinderde stroming** is enkel mogelijk als het stroomopwaartse waterpeil **maximaal 14 cm** ($0.14$ m) boven het stroomafwaartse peil ligt.
* Onder 'vrije stroming' (onderste schuif volledig open) is de stuw passeerbaar voor **76.3%** van de tijd.

---

## 🛠️ Aanbevolen Beheer- en Beleidsmaatregelen
De aanbevelingen zijn gericht op het maximaliseren van de passeerbaarheid via de onderste schuif.

### 1. Operationele Aanbeveling (Optimalisatie Huidig Beheer)
* **Voorkeursbeheer:** Gebruik de **onderste schuif** om de stuw te regelen.
* **Aanbevolen operationele maatregel (Vismigratiestand):**
    * Open de **onderste schuif tot een opening van minstens 30 cm** tussen de bodem en de bovenkant van de schuif.
    * Pas dit toe wanneer het stroomopwaartse peil **minder dan 14 cm hoger** ligt dan het stroomafwaartse peil.

### 2. Beleidsondersteunend Onderzoek
* **Hydraulische modelstudie:** Nodig om de stromingsdynamiek en de effectiviteit van aangepaste beheersstrategieën te simuleren.
* **Ecologische monitoring (telemetrie):** Aangeraden om het daadwerkelijke migratiegedrag van vissen bij de stuw in kaart te brengen.

---

## 📁 Inhoud van de Repository
Deze repository is een **R Markdown project** en bevat de bronbestanden en analysescripts die de basis vormen voor het rapport.

| Bestand / Folder | Type | Beschrijving |
| :--- | :--- | :--- |
| **`code`** | Folder | R-scripts en functies voor dataverwerking en berekeningen. |
| **`data`** | Folder | Ruwe en verwerkte datasets (waterstanden, debieten, stuwstanden) gebruikt voor de analyses. |
| **`output`** | Folder | Gegenereerde bestanden, zoals het uiteindelijke rapport in PDF-formaat (`vispasseerbaarheid-getijstuw-dender.pdf`) en de figuren. |
| **`media`** | Folder | Afbeeldingen en plannen gebruikt in het rapport. |
| `index.Rmd` | Bestand | Het hoofd R Markdown-bestand dat de structuur van het rapport definieert. |
| `000_abstract.Rmd` | Bestand | R Markdown-broncode voor de samenvatting en het Engelse abstract. |
| `01_inleiding.Rmd` | Bestand | R Markdown-broncode voor de inleiding. |
| `03_resultaten.Rmd` | Bestand | R Markdown-broncode voor de resultaten. |
| `04_discussie.Rmd` | Bestand | R Markdown-broncode voor de discussie en aanbevelingen. |
| `zzz_references_and_appendix.Rmd`| Bestand | R Markdown-broncode voor de referenties en de appendix. |
| `references.bib` | Bestand | De bibliografische database in BibTeX-formaat. |
| `_bookdown.yml` | Bestand | Configuratiebestand voor het `bookdown` pakket om het rapport te genereren. |
| `vispasseerbaarheid-getijstuw-dender.Rproj`| Bestand | Het RStudio Project-bestand. |
| `LICENSE.md` | Bestand | De licentie waaronder het werk valt. |
| `cover.txt` | Bestand | Metadata of template voor de covertekst van het rapport. |
| `.gitignore` | Bestand | Lijst van bestanden die Git moet negeren (bijv. gegenereerde output). |

---

## 📧 Contact
Voor vragen of opmerkingen over dit onderzoek kunt u contact opnemen met de auteurs:
* **Stijn Bruneel** (stijn.bruneel@inbo.be).
* **David Buysse**.
* **Johan Coeck**.

---

## 📄 Licentie
Dit werk valt onder een **Creative Commons Attribution 4.0 International**.
