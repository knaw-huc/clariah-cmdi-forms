<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:cmd="http://www.clarin.eu/cmd/"
    xmlns:cmd1="http://www.clarin.eu/cmd/1"
    xmlns:exsl="http://exslt.org/common"
    xmlns:set="http://exslt.org/sets"
    xmlns:str="http://exslt.org/strings"
    exclude-result-prefixes="xs cmd1 exsl set str"
    version="1.0">
    
    <xsl:param name="cmd-toolkit" select="'https://infra.clarin.eu/CMDI/1.x'"/>
    <xsl:param name="cmd-envelop-xsd" select="concat($cmd-toolkit,'/xsd/cmd-envelop.xsd')"/>
    <xsl:param name="cmd-uri" select="'http://www.clarin.eu/cmd/'"/>
    <xsl:param name="cmd-profile" select="''"/>
    <xsl:param name="cmd-1" select="'1.x'"/>
    <xsl:param name="cmd-1_1" select="'1.1'"/>
    <xsl:param name="cmd-1_2" select="'1.2'"/>
    <xsl:param name="cr-uri" select="'http://catalog.clarin.eu/ds/ComponentRegistry/rest/registry'"/>
    <xsl:param name="cr-extension-xsd" select="'/xsd'"/>
    <xsl:param name="cr-extension-xml" select="'/xml'"/>
    
    <xsl:param name="escape" select="'ccmmddii_'"/>

    <!-- CR REST API -->
    <xsl:variable name="cr-profiles" select="concat($cr-uri,'/',$cmd-1,'/profiles')"/>
    
    <xsl:variable name="base">
        <xsl:choose>
            <xsl:when test="normalize-space(/cmd1:CMD/cmd1:Header/cmd1:MdSelfLink)!=''">
                <xsl:value-of select="normalize-space(/cmd1:CMD/cmd1:Header/cmd1:MdSelfLink)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'UNK'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <!-- identity copy -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- try to determine the profile -->
    <xsl:variable name="profile">
        <xsl:variable name="header">
            <xsl:choose>
                <xsl:when test="contains(/cmd1:CMD/cmd1:Header/cmd1:MdProfile,'clarin.eu:cr1:p_')">
                    <xsl:value-of select="concat('clarin.eu:cr1:p_',substring-after(/cmd1:CMD/cmd1:Header/cmd1:MdProfile,'clarin.eu:cr1:p_'))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="''"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="schema"> 
            <xsl:variable name="location">
                <xsl:choose>
                    <xsl:when test="normalize-space(/cmd1:CMD/@xsi:noNamespaceSchemaLocation)!=''">
                        <xsl:message>WRN: <xsl:value-of select="$base"/>: CMDI 1.2 uses namespaces so @xsi:schemaLocation should be used instead of @xsi:schemaLocation!</xsl:message>
                        <xsl:value-of select="normalize-space(/cmd1:CMD/@xsi:noNamespaceSchemaLocation)"/>
                    </xsl:when>
                    <xsl:when test="normalize-space(/cmd1:CMD/@xsi:schemaLocation)!=''">
                        <xsl:variable name="pairs" select="str:tokenize(normalize-space(/cmd1:CMD/@xsi:schemaLocation),' ')"/>
                        <xsl:choose>
                            <xsl:when test="count($pairs)=1">
                                <!-- WRN: improper use of @xsi:schemaLocation! -->
                                <xsl:message>WRN: <xsl:value-of select="$base"/>: @xsi:schemaLocation with single value[<xsl:value-of select="$pairs[1]"/>], should consist of (namespace URI, XSD URI) pairs!</xsl:message>
                                <xsl:value-of select="$pairs[1]"/>
                            </xsl:when>
                            <xsl:when test="$pairs[starts-with(.,'http://www.clarin.eu/cmd/1/profiles')]">
                                <xsl:variable name="pos">
                                    <xsl:for-each select="$pairs">
                                        <xsl:if test="starts-with(.,'http://www.clarin.eu/cmd/1/profiles')">
                                            <xsl:value-of select="position()"/>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:variable>
                                <xsl:if test="$pos &lt;= count($pairs)">
                                    <xsl:value-of select="($pairs)[$pos + 1]"/>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:message>WRN: <xsl:value-of select="$base"/>: no XSD bound to the CMDI 1.2 namespace was found!</xsl:message>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="not(starts-with($location,'http://catalog.clarin.eu/ds/ComponentRegistry/rest/') or starts-with($location,'https://catalog.clarin.eu/ds/ComponentRegistry/rest/'))">
                <xsl:message>WRN: <xsl:value-of select="$base"/>: non-ComponentRegistry XSD[<xsl:value-of select="$location"/>] will be replaced by a CMDI 1.1 ComponentRegistry XSD!</xsl:message>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="contains($location,'clarin.eu:cr1:p_')">
                    <xsl:value-of select="concat('clarin.eu:cr1:p_',substring-before(substring-after($location,'clarin.eu:cr1:p_'),'/'))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="''"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
            
        <xsl:if test="count($header) &gt; 1">
            <xsl:message>WRN: <xsl:value-of select="$base"/>: found more then one profile ID (<xsl:value-of select="$header"/>) in a cmd:MdProfile, will use the first one! </xsl:message>
        </xsl:if>
        <xsl:if test="count($schema) &gt; 1">
            <xsl:message>WRN: <xsl:value-of select="$base"/>: found more then one profile ID (<xsl:value-of select="$schema"/>) in a xsi:schemaLocation, will use the first one! </xsl:message>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="normalize-space(($header)[1])!='' and normalize-space(($schema)[1])!=''">
                <xsl:if test="($header)[1] != ($schema)[1]">
                    <xsl:message>WRN: <xsl:value-of select="$base"/>: the profile IDs found in cmd:MdProfile (<xsl:value-of select="($header)[1]"/>) and xsi:schemaLocation (<xsl:value-of select="($schema)[1]"/>), don't agree, will use the xsi:schemaLocation!</xsl:message>
                </xsl:if>
                <xsl:value-of select="normalize-space(($schema)[1])"/>
            </xsl:when>
            <xsl:when test="normalize-space(($header)[1])!='' and normalize-space(($schema)[1])=''">
                <xsl:value-of select="normalize-space(($header)[1])"/>
            </xsl:when>
            <xsl:when test="normalize-space(($header)[1])='' and normalize-space(($schema)[1])!=''">
                <xsl:value-of select="normalize-space(($schema)[1])"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message terminate="yes">ERR: <xsl:value-of select="$base"/>: the profile ID can't be determined!</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- the profile specific uris -->
    <xsl:variable name="cr-profile-xml"  select="concat($cr-profiles,'/',$profile,$cr-extension-xml)"/>
    <xsl:variable name="cr-profile-xsd"  select="concat($cr-uri,'/',$cmd-1_1,'/profiles/',$profile,$cr-extension-xsd)"/>
    
    <!-- CMD version becomes 1.1 -->
    <xsl:template match="/cmd1:CMD/@CMDVersion">
        <xsl:attribute name="CMDVersion">1.1</xsl:attribute>
    </xsl:template>
    
    <!-- Create our own xsi:schemaLocation -->
    <xsl:template match="@xsi:schemaLocation"/>
    
    <xsl:template match="@xsi:noNamespaceSchemaLocation"/>
    
    <xsl:template match="/cmd1:CMD" priority="1">
        <cmd:CMD>
            <xsl:apply-templates select="set:difference(@*,(@xsi:schemaLocation|@xsi:noNamespaceSchemaLocation))"/>
            <xsl:attribute name="xsi:schemaLocation">
                <xsl:value-of select="$cmd-uri"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$cr-profile-xsd"/>
            </xsl:attribute>
            <xsl:apply-templates select="cmd1:Header"/>
            <xsl:apply-templates select="cmd1:Resources"/>
            <xsl:apply-templates select="cmd1:Components"/>
        </cmd:CMD>
    </xsl:template>
    
    <!-- Make sure cmd:Header contains cmd:MdProfile -->
    <xsl:template match="/cmd1:CMD/cmd1:Header" priority="2">
        <cmd:Header>
            <xsl:apply-templates select="cmd1:MdCreator"/>
            <xsl:apply-templates select="cmd1:MdCreationDate"/>
            <xsl:apply-templates select="cmd1:MdSelfLink"/>
            <cmd:MdProfile>
                <xsl:value-of select="$profile"/>
            </cmd:MdProfile>
            <xsl:apply-templates select="cmd1:MdCollectionDisplayName"/>
        </cmd:Header>
    </xsl:template>
    
    <!-- Skip cmd:Resources/cmd:IsPartOfList -->
    <xsl:template match="/cmd1:CMD/cmd1:Resources" priority="2">
        <cmd:Resources>
            <xsl:apply-templates select="cmd1:ResourceProxyList"/>
            <xsl:apply-templates select="cmd1:JournalFileProxyList"/>
            <xsl:apply-templates select="cmd1:ResourceRelationList"/>
            <xsl:apply-templates select="../cmd1:IsPartOfList"/>
        </cmd:Resources>
    </xsl:template>
    
    <xsl:template match="/cmd1:CMD/cmd1:Resources/cmd1:ResourceRelationList/cmd1:ResourceRelation" priority="2">
        <cmd:ResourceRelation>
            <cmd:Res1>
                <xsl:copy-of select="(cmd:Resource)[1]/@*"/>
            </cmd:Res1>
            <cmd:Res2>
                <xsl:copy-of select="(cmd:Resource)[2]/@*"/>
            </cmd:Res2>
        </cmd:ResourceRelation>
    </xsl:template>
    
    <!-- put everything in the cmd: namespace -->
    <xsl:template match="*" priority="1">
        <xsl:element name="cmd:{local-name()}">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
        
    <!-- delete cmd: namespace from attributes -->
    <xsl:template match="@*[namespace-uri()='http://www.clarin.eu/cmd/1']" priority="1">
        <xsl:attribute name="{local-name()}">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>
    
</xsl:stylesheet>
