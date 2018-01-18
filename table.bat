@echo OFF
java -cp * org.apache.xalan.xslt.Process -IN "%1" -XSL table.xsl -OUT "%2"