<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="html" indent="yes"/>

	<xsl:template match="/">
		<html>
			<head>
				<style type="text/css">
					<![CDATA[
						table {
							font-size: small;
							border-collapse: collapse;
							font-family: Arial, Helvetica, sans-serif;
						}
						th {
							background-color: #D8D8D8;
							text-transform: uppercase;
							border: 1px solid black;
						}
						td {
							with: 20%;
							padding: 3px;
							border: 1px solid black;
						}
						tr.orphan {
							background-color: #0080FF;
						}
						tr.diff {
							background-color: #FE2E2E;
						}
						tr.same {
							background-color: #FFFFFF;
						}
					]]>
				</style>
			</head>
			<body>
				<table>
					<tr>
						<th>Variable Name</th>
						<th>Base Value</th>
						<th>Compare Value</th>
					</tr>
					<xsl:apply-templates select="//compare/group"/>
				</table>
			</body>
		</html>
	</xsl:template>

	<!-- Match on pair group (pair) -->
	<xsl:template match="group">
		<tr>
			<th colspan="3">
				<xsl:value-of select="@name" />
			</th>
		</tr>
		<xsl:apply-templates select="pair">
			<xsl:sort select="name" order="ascending"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="pair">
		<tr>
			<xsl:attribute name="class">
				<xsl:value-of select="@cat" />
			</xsl:attribute>
			<xsl:attribute name="title">
				<xsl:value-of select="@type" />
			</xsl:attribute>
			<td>
				<xsl:value-of select="name" />
			</td>
			<td>
				<xsl:value-of select="value" />
			</td>
			<td>
				<xsl:value-of select="compareValue" />
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>
