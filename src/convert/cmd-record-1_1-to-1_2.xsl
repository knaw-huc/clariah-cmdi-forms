<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:cmd0="http://www.clarin.eu/cmd/"
    xmlns:cmd="http://www.clarin.eu/cmd/1"
    xmlns:exsl="http://exslt.org/common"
    xmlns:set="http://exslt.org/sets"
    xmlns:str="http://exslt.org/strings"
    exclude-result-prefixes="xs cmd0 exsl set str"
    version="1.0">
    
    <xsl:param name="cmd-toolkit" select="'https://infra.clarin.eu/CMDI/1.x'"/>
    <xsl:param name="cmd-envelop-xsd" select="concat($cmd-toolkit,'/xsd/cmd-envelop.xsd')"/>
    <xsl:param name="cmd-uri" select="'http://www.clarin.eu/cmd/1'"/>
    <xsl:param name="cmd-profile" select="''"/>
    <xsl:param name="cmd-1" select="'1.x'"/>
    <xsl:param name="cmd-1_1" select="'1.1'"/>
    <xsl:param name="cmd-1_2" select="'1.2'"/>
    <xsl:param name="cr-uri" select="'http://catalog.clarin.eu/ds/ComponentRegistry/rest/registry'"/>
    <xsl:param name="cr-extension-xsd" select="'/xsd'"/>
    <xsl:param name="cr-extension-xml" select="'/xml'"/>
    
    <xsl:param name="escape" select="'ccmmddii_'"/>

    <!-- namespaces (maybe unresolvable) -->
    <xsl:variable name="cmd-components" select="concat($cmd-uri,'/components')"/>
    <xsl:variable name="cmd-profiles" select="concat($cmd-uri,'/profiles')"/>

    <!-- CR REST API -->
    <xsl:variable name="cr-profiles" select="concat($cr-uri,'/',$cmd-1,'/profiles')"/>
    
    <xsl:variable name="base">
        <xsl:choose>
            <xsl:when test="normalize-space(/cmd0:CMD/cmd0:Header/cmd0:MdSelfLink)!=''">
                <xsl:value-of select="normalize-space(/cmd0:CMD/cmd0:Header/cmd0:MdSelfLink)"/>
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
                <xsl:when test="contains(/cmd0:CMD/cmd0:Header/cmd0:MdProfile,'clarin.eu:cr1:p_')">
                    <xsl:value-of select="concat('clarin.eu:cr1:p_',substring-after(/cmd0:CMD/cmd0:Header/cmd0:MdProfile,'clarin.eu:cr1:p_'))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="''"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="schema"> 
            <xsl:variable name="location">
                <xsl:choose>
                    <xsl:when test="normalize-space(/cmd0:CMD/@xsi:noNamespaceSchemaLocation)!=''">
                        <xsl:message>WRN: <xsl:value-of select="$base"/>: CMDI 1.1 uses namespaces so @xsi:schemaLocation should be used instead of @xsi:schemaLocation!</xsl:message>
                        <xsl:value-of select="normalize-space(/cmd0:CMD/@xsi:noNamespaceSchemaLocation)"/>
                    </xsl:when>
                    <xsl:when test="normalize-space(/cmd0:CMD/@xsi:schemaLocation)!=''">
                        <xsl:variable name="pairs" select="str:tokenize(normalize-space(/cmd0:CMD/@xsi:schemaLocation),' ')"/>
                        <xsl:choose>
                            <xsl:when test="count($pairs)=1">
                                <!-- WRN: improper use of @xsi:schemaLocation! -->
                                <xsl:message>WRN: <xsl:value-of select="$base"/>: @xsi:schemaLocation with single value[<xsl:value-of select="$pairs[1]"/>], should consist of (namespace URI, XSD URI) pairs!</xsl:message>
                                <xsl:value-of select="$pairs[1]"/>
                            </xsl:when>
                            <xsl:when test="$pairs[.='http://www.clarin.eu/cmd/']">
                                <xsl:variable name="pos">
                                    <xsl:for-each select="$pairs">
                                        <xsl:if test=". = 'http://www.clarin.eu/cmd/'">
                                            <xsl:value-of select="position()"/>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:variable>
                                <xsl:if test="$pos &lt;= count($pairs)">
                                    <xsl:value-of select="($pairs)[$pos + 1]"/>
                                </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:message>WRN: <xsl:value-of select="$base"/>: no XSD bound to the CMDI 1.1 namespace was found!</xsl:message>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="not(starts-with($location,'http://catalog.clarin.eu/ds/ComponentRegistry/rest/') or starts-with($location,'https://catalog.clarin.eu/ds/ComponentRegistry/rest/'))">
                <xsl:message>WRN: <xsl:value-of select="$base"/>: non-ComponentRegistry XSD[<xsl:value-of select="$location"/>] will be replaced by a CMDI 1.2 ComponentRegistry XSD!</xsl:message>
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
    <xsl:variable name="cmd-profile-uri" select="concat($cmd-profiles,'/',$profile)"/>
    <xsl:variable name="cr-profile-xml" select="concat($cr-profiles,'/',$profile,$cr-extension-xml)"/>
    <xsl:variable name="cr-profile-xsd">
        <xsl:variable name="prof">
            <xsl:choose>
                <xsl:when test="$cmd-profile">
                    <xsl:value-of select="$cmd-profile"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="document($cr-profile-xml)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <!-- '' means there was no @CMDOriginalVersion, so the original version is 1.2 (the default) -->
            <xsl:when test="exsl:node-set($prof)/ComponentSpec[normalize-space(@CMDOriginalVersion)='' or normalize-space(@CMDOriginalVersion)='1.2']">
                <xsl:value-of select="concat($cr-uri,'/',$cmd-1_1,'/profiles/',$profile,'/',$cmd-1_2,$cr-extension-xsd)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($cr-profiles,'/',$profile,$cr-extension-xsd)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <!-- CMD version becomes 1.2 -->
    <xsl:template match="/cmd0:CMD/@CMDVersion">
        <xsl:attribute name="CMDVersion">1.2</xsl:attribute>
    </xsl:template>
    
    <!-- Create our own xsi:schemaLocation -->
    <xsl:template match="@xsi:schemaLocation"/>
    
    <xsl:template match="@xsi:noNamespaceSchemaLocation"/>
    
    <xsl:template match="/cmd0:CMD">
        <cmd:CMD>
            <xsl:apply-templates select="set:difference(@*,(@xsi:schemaLocation|@xsi:noNamespaceSchemaLocation))"/>
            <xsl:attribute name="xsi:schemaLocation">
                <xsl:value-of select="$cmd-uri"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$cmd-envelop-xsd"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$cmd-profile-uri"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$cr-profile-xsd"/>
            </xsl:attribute>
            <xsl:apply-templates select="cmd0:Header"/>
            <xsl:apply-templates select="cmd0:Resources"/>
            <xsl:apply-templates select="cmd0:Resources/cmd0:IsPartOfList"/>
            <xsl:apply-templates select="cmd0:Components"/>
        </cmd:CMD>
    </xsl:template>
    
    <!-- Make sure cmd:Header contains cmd:MdProfile -->
    <xsl:template match="/cmd0:CMD/cmd0:Header" priority="2">
        <cmd:Header>
            <xsl:apply-templates select="cmd0:MdCreator"/>
            <xsl:apply-templates select="cmd0:MdCreationDate"/>
            <xsl:apply-templates select="cmd0:MdSelfLink"/>
            <cmd:MdProfile>
                <xsl:value-of select="$profile"/>
            </cmd:MdProfile>
            <xsl:apply-templates select="cmd0:MdCollectionDisplayName"/>
        </cmd:Header>
    </xsl:template>
    
    <!-- Skip cmd:Resources/cmd:IsPartOfList -->
    <xsl:template match="/cmd0:CMD/cmd0:Resources" priority="2">
        <cmd:Resources>
            <xsl:apply-templates select="cmd0:ResourceProxyList"/>
            <xsl:apply-templates select="cmd0:JournalFileProxyList"/>
            <xsl:apply-templates select="cmd0:ResourceRelationList"/>
        </cmd:Resources>
    </xsl:template>
    
    <!-- Reshape ResourceRelationList -->
    <xsl:template match="/cmd0:CMD/cmd0:Resources/cmd0:ResourceRelationList/cmd0:ResourceRelation/cmd0:RelationType" priority="2">
        <cmd:RelationType>
            <!-- take the string value, ignore deeper structure -->
            <xsl:value-of select="."/>
        </cmd:RelationType>
    </xsl:template>
    
    <xsl:template match="/cmd0:CMD/cmd0:Resources/cmd0:ResourceRelationList/cmd0:ResourceRelation" priority="2">
        <xsl:choose>
            <xsl:when test="normalize-space(cmd0:Res1/@ref)='' or normalize-space(cmd0:Res2/@ref)=''">
                <xsl:message>WRN: <xsl:value-of select="$base"/>: incomplete ResourceRelation, which will be ignored!</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <cmd:ResourceRelation>
                    <xsl:apply-templates select="@*|node()"/>
                </cmd:ResourceRelation>
            </xsl:otherwise>
        </xsl:choose>
            
    </xsl:template>
    
    <xsl:template match="/cmd0:CMD/cmd0:Resources/cmd0:ResourceRelationList/cmd0:ResourceRelation/cmd0:Res1" priority="2">
        <cmd:Resource>
            <xsl:apply-templates select="@*"/>
            <cmd:Role>Res1</cmd:Role>
        </cmd:Resource>
    </xsl:template>
    
    <xsl:template match="/cmd0:CMD/cmd0:Resources/cmd0:ResourceRelationList/cmd0:ResourceRelation/cmd0:Res2" priority="2">
        <cmd:Resource>
            <xsl:apply-templates select="@*"/>
            <cmd:Role>Res2</cmd:Role>
        </cmd:Resource>
    </xsl:template>
    
    <!-- put envelop in the envelop namespace -->
    <xsl:template match="/cmd0:CMD//*" priority="1">
        <xsl:element name="cmd:{local-name()}">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
    
    <!-- put payload in the profile namespace -->
    <xsl:template match="/cmd0:CMD/cmd0:Components//*" priority="2">
        <xsl:element namespace="{$cmd-profile-uri}" name="cmdp:{local-name()}">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
    
    <!-- unescape downgraded CMDI 1.2 attributes -->
    <xsl:template match="/cmd0:CMD/cmd0:Components//@*[name()=local-name()]" priority="2">
        <xsl:choose>
            <xsl:when test="starts-with(name(),$escape)">
                <xsl:attribute name="{substring-after(name(),$escape)}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- move CMD attributes to the CMD namespace -->
    <xsl:template match="/cmd0:CMD/cmd0:Components//@ref" priority="3">
        <xsl:choose>
            <xsl:when test="parent::*/text()[normalize-space()!='']">
                <!-- this is an element keep the @ref -->
                <xsl:message>INF: this is an element keep the ref</xsl:message>
                <xsl:copy/>
            </xsl:when>
            <xsl:when test="../node() or parent::*/@ComponentId">
                <!-- the parent is a component add the namespace to @ref -->
                <xsl:message>INF: this is an component add the namespace to ref</xsl:message>
                <xsl:attribute name="cmd:ref">
                    <xsl:variable name="refs" select="str:tokenize(.,' ')"/>
                    <xsl:if test="count($refs) &gt; 1">
                        <xsl:message>WRN: <xsl:value-of select="$base"/>: CMDI 1.2 doesn't support references to multiple ResourceProxies! Only the first reference is kept.</xsl:message>
                    </xsl:if>
                    <xsl:value-of select="$refs[1]"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <!-- don't know if the parent is a component without children, or an element without value
                     have a look at the profile -->
                <xsl:variable name="prof">
                    <xsl:choose>
                        <xsl:when test="$cmd-profile">
                            <xsl:value-of select="$cmd-profile"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="document($cr-profile-xml)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="path">
                    <xsl:for-each select="ancestor::*">
                        <xsl:if test="local-name()!='CMD' and local-name()!='Components'">
                            <xsl:value-of select="local-name()"/>
                            <xsl:if test="not(last())">
                                <xsl:text>/</xsl:text>
                            </xsl:if>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:message>DBG: path[<xsl:value-of select="$path"/>]</xsl:message>
                <xsl:variable name="attr">
                    <xsl:for-each select="exsl:node-set($prof)//Attribute[@name='ref']">
                        <xsl:variable name="a">
                            <xsl:for-each select="ancestor::*">
                                <xsl:if test="local-name()='Component' or local-name()!='Element'">
                                    <xsl:value-of select="@name"/>
                                    <xsl:if test="not(last())">
                                        <xsl:text>/</xsl:text>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:message>DBG: a[<xsl:value-of select="$a"/>]</xsl:message>
                        <xsl:if test="$a = $path">
                            <xsl:value-of select="$a"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:message>DBG: attr[<xsl:value-of select="$attr"/>]</xsl:message>
                <xsl:choose>
                    <xsl:when test="normalize-space($attr)!=''">
                        <!-- in CMDI 1.1 @ref can only be an user declared attribute for an element -->
                        <xsl:message>INF: according to the profile this @ref is an user declared attribute, so keep the ref</xsl:message>
                        <xsl:copy/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- this is an undeclared @ref, so add the namespace -->
                        <xsl:message>INF: according to the profile this @ref is not user defined, so add the namespace</xsl:message>
                        <xsl:attribute name="cmd:ref">
                            <xsl:variable name="refs" select="str:tokenize(.,' ')"/>
                            <xsl:if test="count($refs) &gt; 1">
                                <xsl:message>WRN: <xsl:value-of select="$base"/>: CMDI 1.2 doesn't support references to multiple ResourceProxies! Only the first reference is kept.</xsl:message>
                            </xsl:if>
                            <xsl:value-of select="$refs[1]"/>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="/cmd0:CMD/cmd0:Components//@ComponentId" priority="2">
        <xsl:attribute name="cmd:ComponentId">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

</xsl:stylesheet>
