@echo OFF
java -cp * org.apache.xalan.xslt.Process -IN "%1" -XSL compare.xsl -OUT "%3" -PARAM compareXmlPath "%2"