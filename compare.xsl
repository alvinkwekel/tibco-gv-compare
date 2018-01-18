<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xalan" xmlns:am="http://www.tibco.com/xmlns/ApplicationManagement" xmlns:str="xalan://java.lang.String" xmlns:obf="xalan://com.tibco.security.ObfuscationEngine">
	<xsl:param name="compareXmlPath" select="'.*'"/>
	<xsl:param name="compareXml" select="document($compareXmlPath)"/>
	<xsl:param name="baseXml" select="/"/>

	<xsl:output method="xml" indent="yes" xalan:indent-amount="5"/>

	<xsl:template match="/">
		<compare>
			<xsl:attribute name="baseName">
				<xsl:value-of select="//am:application/@name" />
			</xsl:attribute>
			<xsl:attribute name="compareName">
				<xsl:value-of select="$compareXml//am:application/@name" />
			</xsl:attribute>
			<xsl:apply-templates select="//am:NVPairs"/>
		</compare>
	</xsl:template>

	<!-- Match on NVPair group (NVPairs) -->
	<xsl:template match="am:NVPairs">
		<group>
			<!-- set name attribute to identify group -->
			<xsl:attribute name="name">
				<xsl:value-of select="@name" />
			</xsl:attribute>

			<!-- Go over nv pairs -->
			<xsl:apply-templates select="./*"/>

			<!-- Go over orphan nv pairs in compare xml -->
			<xsl:apply-templates select="$compareXml//am:NVPairs[@name=current()/@name]/*[not(am:name = current()/*/am:name)]"/>
		</group>
	</xsl:template>

	<!-- Seems to be needed to support match="am:NVPairs/*" -->
	<xsl:template match="am:NVPairs/*">
		<xsl:variable name="baseName" select="./am:name/text()"/>
		<!-- Variables are not initilized when the element is not found. So a check for existance can be done on those -->
		<xsl:variable name="baseValuePure" select="$baseXml//am:NVPairs[@name=current()/../@name]/*[am:name/text()=$baseName]/am:value"/>	
		<xsl:variable name="compareValuePure" select="$compareXml//am:NVPairs[@name=current()/../@name]/*[am:name/text()=$baseName]/am:value"/>	
		
		<!-- pass all values to decrypt template -->
		<xsl:variable name="baseValue">
			<xsl:call-template name="decrypt">
				<xsl:with-param name="value" select="$baseValuePure"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="compareValue">
			<xsl:call-template name="decrypt">
				<xsl:with-param name="value" select="$compareValuePure"/>
			</xsl:call-template>
		</xsl:variable>
		<pair>
			<!-- category of the compare -->
			<xsl:attribute name="cat">
				<xsl:choose>
					<xsl:when test="not($baseValuePure) or not($compareValuePure)">
						<xsl:value-of select="'orphan'" />
					</xsl:when>
					<xsl:when test="not($baseValue = $compareValue)">
						<xsl:value-of select="'diff'" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="'same'" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<!-- type of nv pair -->
			<xsl:attribute name="type">
						<xsl:value-of select="local-name()" />
			</xsl:attribute>
			<name>
				<xsl:value-of select="$baseName"/>
			</name>
			<value>
				<xsl:value-of select="$baseValue"/>
			</value>
			<compareValue>
				<xsl:value-of select="$compareValue"/>
			</compareValue>
		</pair>
	</xsl:template>

	<!-- decrypt passwords using tibco method -->
	<xsl:template name="decrypt">
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="starts-with($value, '#!')">
				<xsl:value-of select="str:new(obf:decrypt($value))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	

</xsl:stylesheet>