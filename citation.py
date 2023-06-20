
import re
software = {
    "antismash": {
        "publication": "Kai Blin and others, antiSMASH 6.0: improving cluster detection and comparison capabilities, Nucleic Acids Research, Volume 49, Issue W1, 2 July 2021, Pages W29-W35, 10.1093/nar/gkab335"
    },
    "diamond": {
        "publication": "Buchfink, B., Reuter, K. & Drost, HG. Sensitive protein alignments at tree-of-life scale using DIAMOND. Nat Methods 18, 366-368 (2021). 10.1038/s41592-021-01101-x"
    },
    "hmmer": {
        "publication": "Eddy SR. Accelerated Profile HMM Searches. PLoS Comput Biol. 2011 Oct;7(10):e1002195. doi: 10.1371/journal.pcbi.1002195"
    },
    "mmseqs2": {
        "publication": "Steinegger, M., Söding, J. MMseqs2 enables sensitive protein sequence searching for the analysis of massive data sets. Nat Biotechnol 35, 1026-1028 (2017). 10.1038/nbt.3988"
    },
    "ncbi-genome-download": {
        "publication": "Maybe cite the GitHub repo? Discussion here: https://github.com/kblin/ncbi-genome-download/issues/207"
    },
    "ncbi_datasets": {"publication": "https://github.com/ncbi/datasets"},
    "neo4j": {
        "publication": "Robinson, I., Webber, J. & Eifrem, E. Graph Databases: New Opportunities for Connected Data. (O'Reilly Media, Inc., 2015)."
    },
    "nf-core": {
        "publication": "Ewels PA, Peltzer A, Fillinger S, Patel H, Alneberg J, Wilm A, Garcia MU, Di Tommaso P, Nahnsen S. The nf-core framework for community-curated bioinformatics pipelines. Nat Biotechnol. 2020 Mar;38(3):276-278. doi: 10.1038/s41587-020-0439-x"
    },
}


databases = {
    "amrfinder": {
        "publication": "Feldgarden M, Brover V, Gonzalez-Escalona N, Frye JG, Haendiges J, Haft DH, Hoffmann M, Pettengill JB, Prasad AB, Tillman GE, Tyson GH, Klimke W. AMRFinderPlus and the Reference Gene Catalog facilitate examination of the genomic links among antimicrobial resistance, stress response, and virulence. Sci Rep. 2021 Jun 16;11(1):12728. doi: 10.1038/s41598-021-91456-0",
        "license":"https://github.com/ncbi/amr/wiki/Licenses",
        "website":"https://www.ncbi.nlm.nih.gov/pathogens/antimicrobial-resistance/AMRFinder/"
    },
    "antismash": {
        "publication": "Kai Blin and others, antiSMASH 6.0: improving cluster detection and comparison capabilities, Nucleic Acids Research, Volume 49, Issue W1, 2 July 2021, Pages W29-W35, 10.1093/nar/gkab335",
        "license":"https://github.com/antismash/antismash/blob/master/LICENSE.txt",
        "website":"https://antismash.secondarymetabolites.org/"
    },
    "bigslice": {
        "publication": "Kautsar SA, van der Hooft JJJ, de Ridder D, Medema MH. BiG-SLiCE: A highly scalable tool maps the diversity of 1.2 million biosynthetic gene clusters. Gigascience. 2021 Jan 13;10(1):giaa154. doi: 10.1093/gigascience/giaa154",
        "license":"https://github.com/medema-group/bigslice/blob/master/LICENSE.txt",
        "website":"https://bigfam.bioinformatics.nl/home"
    },
    "classiphage": {
        "publication": "Chibani CM, Farr A, Klama S, Dietrich S, Liesegang H. Classifying the Unclassified: A Phage Classification Method. Viruses. 2019 Feb 24;11(2):195. doi: 10.3390/v11020195",
        "license": "No license found",
        "website":"http://appmibio.uni-goettingen.de/software/ClassiPhage/"
    },
    "goterms": {
        "publication": [
            "Ashburner M, Ball CA, Blake JA, Botstein D, Butler H, Cherry JM, Davis AP, Dolinski K, Dwight SS, Eppig JT, Harris MA, Hill DP, Issel-Tarver L, Kasarskis A, Lewis S, Matese JC, Richardson JE, Ringwald M, Rubin GM, Sherlock G. Gene ontology: tool for the unification of biology. The Gene Ontology Consortium. Nat Genet. 2000 May;25(1):25-9. doi: 10.1038/75556",
            "Gene Ontology Consortium; Aleksander SA, Balhoff J, Carbon S, Cherry JM, Drabkin HJ, Ebert D, Feuermann M, Gaudet P, Harris NL, Hill DP, Lee R, Mi H, Moxon S, Mungall CJ, Muruganugan A, Mushayahama T, Sternberg PW, Thomas PD, Van Auken K, Ramsey J, Siegele DA, Chisholm RL, Fey P, Aspromonte MC, Nugnes MV, Quaglia F, Tosatto S, Giglio M, Nadendla S, Antonazzo G, Attrill H, Dos Santos G, Marygold S, Strelets V, Tabone CJ, Thurmond J, Zhou P, Ahmed SH, Asanitthong P, Luna Buitrago D, Erdol MN, Gage MC, Ali Kadhum M, Li KYC, Long M, Michalak A, Pesala A, Pritazahra A, Saverimuttu SCC, Su R, Thurlow KE, Lovering RC, Logie C, Oliferenko S, Blake J, Christie K, Corbani L, Dolan ME, Drabkin HJ, Hill DP, Ni L, Sitnikov D, Smith C, Cuzick A, Seager J, Cooper L, Elser J, Jaiswal P, Gupta P, Jaiswal P, Naithani S, Lera-Ramirez M, Rutherford K, Wood V, De Pons JL, Dwinell MR, Hayman GT, Kaldunski ML, Kwitek AE, Laulederkind SJF, Tutaj MA, Vedi M, Wang SJ, D'Eustachio P, Aimo L, Axelsen K, Bridge A, Hyka-Nouspikel N, Morgat A, Aleksander SA, Cherry JM, Engel SR, Karra K, Miyasato SR, Nash RS, Skrzypek MS, Weng S, Wong ED, Bakker E, Berardini TZ, Reiser L, Auchincloss A, Axelsen K, Argoud-Puy G, Blatter MC, Boutet E, Breuza L, Bridge A, Casals-Casas C, Coudert E, Estreicher A, Livia Famiglietti M, Feuermann M, Gos A, Gruaz-Gumowski N, Hulo C, Hyka-Nouspikel N, Jungo F, Le Mercier P, Lieberherr D, Masson P, Morgat A, Pedruzzi I, Pourcel L, Poux S, Rivoire C, Sundaram S, Bateman A, Bowler-Barnett E, Bye-A-Jee H, Denny P, Ignatchenko A, Ishtiaq R, Lock A, Lussi Y, Magrane M, Martin MJ, Orchard S, Raposo P, Speretta E, Tyagi N, Warner K, Zaru R, Diehl AD, Lee R, Chan J, Diamantakis S, Raciti D, Zarowiecki M, Fisher M, James-Zorn C, Ponferrada V, Zorn A, Ramachandran S, Ruzicka L, Westerfield M. The Gene Ontology knowledgebase in 2023. Genetics. 2023 May 4;224(1):iyad031. doi: 10.1093/genetics/iyad031",
        ],
        "license": "http://geneontology.org/docs/go-citation-policy/",
        "website":"http://geneontology.org/"
    },
    "ipresto": {
        "publication": "Louwen JJR, Kautsar SA, van der Burg S, Medema MH, van der Hooft JJJ. iPRESTO: Automated discovery of biosynthetic sub-clusters linked to specific natural product substructures. PLoS Comput Biol. 2023 Feb 9;19(2):e1010462. doi: 10.1371/journal.pcbi.1010462",
        "license":"https://git.wageningenur.nl/bioinformatics/iPRESTO/-/blob/master/LICENSE",
        "website":"https://git.wageningenur.nl/bioinformatics/iPRESTO/"
    },
    "mibig": {
        "publication": "Terlouw BR, Blin K, Navarro-Muñoz JC, Avalon NE, Chevrette MG, Egbert S, Lee S, Meijer D, Recchia MJJ, Reitz ZL, van Santen JA, Selem-Mojica N, Tørring T, Zaroubi L, Alanjary M, Aleti G, Aguilar C, Al-Salihi SAA, Augustijn HE, Avelar-Rivas JA, Avitia-Domínguez LA, Barona-Gómez F, Bernaldo-Agüero J, Bielinski VA, Biermann F, Booth TJ, Carrion Bravo VJ, Castelo-Branco R, Chagas FO, Cruz-Morales P, Du C, Duncan KR, Gavriilidou A, Gayrard D, Gutiérrez-García K, Haslinger K, Helfrich EJN, van der Hooft JJJ, Jati AP, Kalkreuter E, Kalyvas N, Kang KB, Kautsar S, Kim W, Kunjapur AM, Li YX, Lin GM, Loureiro C, Louwen JJR, Louwen NLL, Lund G, Parra J, Philmus B, Pourmohsenin B, Pronk LJU, Rego A, Rex DAB, Robinson S, Rosas-Becerra LR, Roxborough ET, Schorn MA, Scobie DJ, Singh KS, Sokolova N, Tang X, Udwary D, Vigneshwari A, Vind K, Vromans SPJM, Waschulin V, Williams SE, Winter JM, Witte TE, Xie H, Yang D, Yu J, Zdouc M, Zhong Z, Collemare J, Linington RG, Weber T, Medema MH. MIBiG 3.0: a community-driven effort to annotate experimentally validated biosynthetic gene clusters. Nucleic Acids Res. 2023 Jan 6;51(D1):D603-D610. doi: 10.1093/nar/gkac1049",
        "website": "https://mibig.secondarymetabolites.org/",
        "license":"Creative Commons Attribution 4.0 International License"
    },
        "pfam": {
        "publication": "Jaina Mistry and others, Pfam: The protein families database in 2021, Nucleic Acids Research, Volume 49, Issue D1, 8 January 2021, Pages D412-D419, 10.1093/nar/gkaa913",
        "website":"'Pfam is freely available under the Creative Commons Zero (“CC0”) licence.'; https://www.ebi.ac.uk/interpro/entry/pfam",
        "license": "https://pfam-docs.readthedocs.io/en/latest/"

    },
    "prism": {
        "publication": "Skinnider MA, Merwin NJ, Johnston CW, Magarvey NA. PRISM 3: expanded prediction of natural product chemical structures from microbial genomes. Nucleic Acids Res. 2017 Jul 3;45(W1):W49-W54. doi: 10.1093/nar/gkx320",
        "license": "No redistribution allowed",
    },
    "resfams": {
        "publication": "Gibson MK, Forsberg KJ, Dantas G. Improved annotation of antibiotic resistance determinants reveals microbial resistomes cluster by ecology. ISME J. 2015 Jan;9(1):207-16. doi: 10.1038/ismej.2014.106",
        "license":"http://www.dantaslab.org/s/LICENSE.txt",
        "website":"http://www.dantaslab.org/resfams"
    },
    "tigrfam": {
        "publication": "Haft DH, Selengut JD, White O. The TIGRFAMs database of protein families. Nucleic Acids Res. 2003 Jan 1;31(1):371-3. doi: 10.1093/nar/gkg128",
        "license":"https://creativecommons.org/licenses/by-sa/4.0/legalcode",
        "website":"'TIGRFAMs data are made available under a Creative Commons Attribution-ShareAlike 4.0 license.'; https://www.ncbi.nlm.nih.gov/genome/annotation_prok/tigrfams/"
    },
    "vogdb": {"publication": "Note sure the reference; https://vogdb.org",
        "license": "No license found",
              "website":"https://vogdb.org/"},
}

yaml_path="/home/chase/Documents/socialgene_data/mibig/socialgene_per_run/pipeline_info/software_versions.yml"
with open(yaml_path, "r") as h:
    a=h.read()

class Citation():
    __slots__=["name", "publication", "license", "website"]
    def __init__(self, name=None, publication=None, license=None, website=None, **kwargs) -> None:
        self.name=name
        self.publication=publication
        self.license=license
        self.website=website
    def get(self):
        out_str = ""
        out_str = out_str + f"{self.name}:\n"
        if self.publication:
            out_str = out_str + f"  publication: '{self.publication}'\n"
        if self.license:
            out_str = out_str + f"  license: '{self.license}'\n"
        if self.website:
            out_str = out_str + f"  website: '{self.website}'\n"
        out_str = out_str + "\n"
        return out_str
    def write(self, outpath, mode="a", **kwargs):
        with open(outpath, mode=mode) as h:
            h.write(self.get())



z=[]
for k,v in databases.items():
    if re.search( k,a, re.IGNORECASE):
        z=Citation(name=k, **v).write(yaml_path)



z=[]
for k,v in software.items():
    if re.search( k,a, re.IGNORECASE):
        Citation(name=k, **v).write(yaml_path)

