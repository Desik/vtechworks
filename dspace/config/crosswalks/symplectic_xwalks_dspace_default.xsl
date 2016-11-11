<?xml version="1.0" encoding="utf-8"?>
<!--
  ~ Copyright (c) 2012 Symplectic Ltd. All Rights Reserved
    Symplectic Crosswalks Toolkit: version 1.4.0
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:crosswalks="info:symplectic/crosswalks"
    xmlns:atom="http://www.w3.org/2005/Atom"
    xmlns:pubs="http://www.symplectic.co.uk/publications/atom-api"
    exclude-result-prefixes="atom pubs crosswalks"
    version="1.0">
    <!-- Required for all crosswalks - import the standard toolkit -->
    <xsl:import href="symplectic_xwalks_toolkit.xsl" />
    
    <!-- Required for all crosswalks - load the data islands from the crosswalk stylesheet -->
    <xsl:variable name="crosswalk-mappings" select="document('')//crosswalks:mappings" />
    <xsl:variable name="crosswalk-object-mappings" select="document('')//crosswalks:object-mappings" />
    <!-- xsl:variable name="crosswalk-label-mappings" select="document('')//crosswalks:label-mappings" / -->
    <xsl:variable name="crosswalk-dictionaries" select="document('')//crosswalks:dictionaries" />
    <xsl:variable name="crosswalk-datasource-precedences" select="document('')//crosswalks:datasource-precedences" />
    
    <!--
        Data Source Mappings
        ====================
        Map values from the data source into repository fields
    -->
    <crosswalks:mappings for="dspace">
        <!-- Default mappings -->
        <crosswalks:mapping dspace="dc.type" feed-elements="category" />
        <crosswalks:mapping dspace="dc.type.other" elements="types" />
        <crosswalks:mapping dspace="dc.contributor.author" elements="authors,associated-authors" />
        <crosswalks:mapping dspace="dc.contributor.editor" elements="editors" />
        <crosswalks:mapping dspace="dc.coverage.spatial" elements="location" />
        <crosswalks:mapping dspace="dc.date.issued" elements="publication-date" />
        <crosswalks:mapping dspace="dc.date.available" elements="online-publication-date" />
        <crosswalks:mapping dspace="dcterms.dateAccepted" elements="acceptance-date" />
        <crosswalks:mapping dspace="dc.description.abstract" elements="abstract" />
        <crosswalks:mapping dspace="dc.format.medium" elements="medium" />
        <crosswalks:mapping dspace="dc.format.extent" format-elements="~[$pagination] page(s)~" />
        <crosswalks:mapping dspace="dc.format.extent"	format-elements="~[$number-of-pieces] chapter(s)~" /> 
        <crosswalks:mapping dspace="dc.identifier.other" format-elements="pii,number,external-identifiers" />
        <crosswalks:mapping dspace="dc.identifier.doi" elements="doi" />
        <crosswalks:mapping dspace="dc.identifier.eissn" elements="eissn" />
        <crosswalks:mapping dspace="dc.identifier.isbn" elements="isbn-10,isbn-13" />
        <crosswalks:mapping dspace="dc.identifier.issn" elements="issn" />
        <crosswalks:mapping dspace="dc.language" elements="language" />
        <crosswalks:mapping dspace="dc.publisher" elements="publisher" />
        <crosswalks:mapping dspace="dc.relation.ispartof" elements="name-of-conference,parent-title,series" />
        <crosswalks:mapping dspace="dc.title.serial" elements="journal" />
        <crosswalks:mapping dspace="dc.identifier.volume" elements="volume" />
        <crosswalks:mapping dspace="dc.identifier.issue" elements="issue" />
        <crosswalks:mapping dspace="dc.subject" elements="keywords" />
        <crosswalks:mapping dspace="dc.title" elements="title" />
        <crosswalks:mapping dspace="dc.description.notes" elements="fulltext-comment,notes" />
        <crosswalks:mapping dspace="dc.description.version" format-elements="~[$publication-status] (Publication status)~" />
        <crosswalks:mapping dspace="dc.description.notes" format-elements="~[$c-review-type:list(, )] (Peer reviewed?)~" />
        <crosswalks:mapping dspace="dc.description.notes" format-elements="~[$c-invited] (Invited?)~" />
        <crosswalks:mapping dspace="dc.description.provenance" elements="addresses,record-created-at-source-date" />
        <crosswalks:mapping dspace="dc.description.provenance" elements="~[$are-files-confidential] (Are files confidential?)" />
        <crosswalks:mapping dspace="dc.description.provenance" elements="~[$confidential] (Confidential?)" />
        <crosswalks:mapping dspace="dc.description.provenance" elements="~[$confidential-files-reason] (Reason for confidentiality)" />
        <crosswalks:mapping dspace="dc.description.sponsorship" elements="funding-acknowledgements,funder-name,funder-reference,institution-reference" />
        <crosswalks:mapping dspace="dc.description.version" elements="version" />
        <crosswalks:mapping dspace="dc.rights" elements="author-licence,publisher-licence" />
        <crosswalks:mapping dspace="dcterms.references" elements="references" />
        <crosswalks:mapping dspace="dc.relation.uri" elements="author-url,publisher-url,url" />
        <crosswalks:mapping dspace="dc.date.issued" elements="awarded-date" />
        <crosswalks:mapping dspace="dc.contributor.assignee" elements="commissioning-body" />
        <crosswalks:mapping dspace="dc.description.version" format-elements="~[$edition] (Edition)~" />
        <crosswalks:mapping dspace="dc.date.filed" elements="filed-date" />
        <crosswalks:mapping dspace="pubs.finish-date" elements="finish-date" />
        <crosswalks:mapping dspace="dc.identifier.patentnumber" elements="patent-number" />
        <crosswalks:mapping dspace="pubs.patent-status" elements="patent-status" />
        <crosswalks:mapping dspace="pubs.place-of-publication" elements="place-of-publication" />
        <crosswalks:mapping dspace="pubs.repository-status" elements="repository-status" />
        <crosswalks:mapping dspace="pubs.start-date" elements="start-date" />
        <crosswalks:mapping dspace="dc.description.notes" format-elements="~[$c-extension] (Extension publication?)~" />
    </crosswalks:mappings>
    
    <!-- Override the boolean mapping template for formatted booleans -->  
    <xsl:template match="pubs:boolean" mode="formatted">  
          <xsl:param name="name" />  
          <xsl:param name="repo_field" />  
   
        <!-- Custom XSL: Only map booleans when they are for a field other than c-invited, or are not equal to false. -->  
        <xsl:if test="$name != 'c-invited' or . != 'false'">  
            <xsl:apply-templates select=".">  
                <xsl:with-param name="name" select="$name" />  
                <xsl:with-param name="repo_field" select="$repo_field" />  
            </xsl:apply-templates>  
        </xsl:if>  
    </xsl:template>
    
    <!--
        Object level field mappings
        ===========================
        Map values from the publication fields into repository fields
    -->
    <crosswalks:object-mappings for="dspace">
            <crosswalks:mapping dspace="dc.description.notes" elements="fulltext-comment" />
            These mappings are for the OA location selection
            <crosswalks:mapping dspace="dc.identifier.url" elements="p-oa-location" />
            <crosswalks:mapping dspace="dc.description.version" elements="p-oa-location-file-version" />
        <crosswalks:mapping dspace="dc.rights" elements="p-author-license,p-publisher-licence" />
        <crosswalks:mapping dspace="dc.rights.uri" elements="p-author-license,p-publisher-licence" />
        <!--Added to allow mapping to customized Creative Commons 4.0 license text, as well as to add associated Creative Commons 4.0 URIs-->
    </crosswalks:object-mappings>
    
    <!--
        Label mappings
        ==============
    -->
    <!--
        <crosswalks:label-mappings for="dspace">
            <crosswalks:label-mapping dspace="dc.subject" list-separator=", ">
                <crosswalks:label-mapping origin="issn-inferred" />
                <crosswalks:label-mapping exclude-scheme="for" />
            </crosswalks:label-mapping>
            <crosswalks:label-mapping dspace="dc.subject" list-separator="; ">
                <crosswalks:label-mapping exclude-scheme="for" />
            </crosswalks:label-mapping>
            <crosswalks:label-mapping dspace="dc.subject" />
        </crosswalks:label-mappings>
    -->
    
    <!--
        Data Dictionaries
        =================
        Convert values supplied by Elements to values used in DSpace
    -->
    <crosswalks:dictionaries>
        <crosswalks:dictionary dspace="dc.type" mapped-only="true">
            <crosswalks:entry elements="http://www.symplectic.co.uk/publications/atom-terms/1.0/artefact"               dspace="artefact" />
            <crosswalks:entry elements="http://www.symplectic.co.uk/publications/atom-terms/1.0/book"                   dspace="book" />
            <crosswalks:entry elements="http://www.symplectic.co.uk/publications/atom-terms/1.0/chapter"                dspace="book_section" />
            <crosswalks:entry elements="http://www.symplectic.co.uk/publications/atom-terms/1.0/composition"            dspace="composition" />
            <crosswalks:entry elements="http://www.symplectic.co.uk/publications/atom-terms/1.0/conference-proceeding"  dspace="conference_item" />
            <crosswalks:entry elements="http://www.symplectic.co.uk/publications/atom-terms/1.0/design"                 dspace="artefact" />
            <crosswalks:entry elements="http://www.symplectic.co.uk/publications/atom-terms/1.0/exhibition"             dspace="exhibition" />
            <crosswalks:entry elements="http://www.symplectic.co.uk/publications/atom-terms/1.0/internet-publication"   dspace="internet_publication" />
            <crosswalks:entry elements="http://www.symplectic.co.uk/publications/atom-terms/1.0/journal-article"        dspace="article" />
            <crosswalks:entry elements="http://www.symplectic.co.uk/publications/atom-terms/1.0/other"                  dspace="other" />
            <crosswalks:entry elements="http://www.symplectic.co.uk/publications/atom-terms/1.0/patent"                 dspace="patent" />
            <crosswalks:entry elements="http://www.symplectic.co.uk/publications/atom-terms/1.0/performance"            dspace="performance" />
            <crosswalks:entry elements="http://www.symplectic.co.uk/publications/atom-terms/1.0/poster"                 dspace="poster" />
            <crosswalks:entry elements="http://www.symplectic.co.uk/publications/atom-terms/1.0/report"                 dspace="report" />
            <crosswalks:entry elements="http://www.symplectic.co.uk/publications/atom-terms/1.0/scholarly-edition"      dspace="monograph" />
            <crosswalks:entry elements="http://www.symplectic.co.uk/publications/atom-terms/1.0/software"               dspace="software" />
            <crosswalks:entry elements="http://www.symplectic.co.uk/publications/atom-terms/1.0/thesis-or-dissertation" dspace="thesis" />
        </crosswalks:dictionary>
    
    <crosswalks:dictionary dspace="dc.rights" mapped-only="true">
        <crosswalks:entry elements="CC BY" dspace="Attribution 4.0 International" />
        <crosswalks:entry elements="CC BY-ND" dspace="Attribution-NoDerivatives 4.0 International" />
        <crosswalks:entry elements="CC BY-SA" dspace="Attribution-ShareAlike 4.0 International" />
        <crosswalks:entry elements="CC BY-NC" dspace="Attribution-NonCommercial 4.0 International" />
        <crosswalks:entry elements="CC BY-NC-ND" dspace="Attribution-NonCommercial-NoDerivatives 4.0 International" />
        <crosswalks:entry elements="CC BY-NC-SA" dspace="Attribution-NonCommercial-ShareAlike 4.0 International" />
        <crosswalks:entry elements="Publisher's own licence" dspace="Publisher's own licence" />
        <crosswalks:entry elements="Unknown" dspace="Unknown" />
    </crosswalks:dictionary>
    
    <crosswalks:dictionary dspace="dc.rights.uri" mapped-only="true">
        <crosswalks:entry elements="CC BY" dspace="http://creativecommons.org/licenses/by/4.0/" />
        <crosswalks:entry elements="CC BY-ND" dspace="http://creativecommons.org/licenses/by-nd/4.0/" />
        <crosswalks:entry elements="CC BY-SA" dspace="http://creativecommons.org/licenses/by-sa/4.0/" />
        <crosswalks:entry elements="CC BY-NC" dspace="http://creativecommons.org/licenses/by-nc/4.0/" />
        <crosswalks:entry elements="CC BY-NC-ND" dspace="http://creativecommons.org/licenses/by-nc-nd/4.0/" />
        <crosswalks:entry elements="CC BY-NC-SA" dspace="http://creativecommons.org/licenses/by-nc-sa/4.0/" />
    </crosswalks:dictionary>
    
    </crosswalks:dictionaries>
    
    <!--
        Data Source Precedences
        =======================
        Used when passing the full atom feed from Repository Tools.
        Please check your Elements instance to see what data sources are being used.
        Only data sources listed here will be considered for mapping.
    -->
    <crosswalks:datasource-precedences>
        <crosswalks:datasource-precedence>web-of-science</crosswalks:datasource-precedence>
        <crosswalks:datasource-precedence>wos-lite</crosswalks:datasource-precedence>
        <crosswalks:datasource-precedence>pubmed</crosswalks:datasource-precedence>
        <crosswalks:datasource-precedence>isi-precedings</crosswalks:datasource-precedence>
        <crosswalks:datasource-precedence>manual-entry</crosswalks:datasource-precedence>
        <crosswalks:datasource-precedence>arxiv</crosswalks:datasource-precedence>
        <crosswalks:datasource-precedence>dblp</crosswalks:datasource-precedence>
        <crosswalks:datasource-precedence>scopus</crosswalks:datasource-precedence>
    </crosswalks:datasource-precedences>
</xsl:stylesheet>
