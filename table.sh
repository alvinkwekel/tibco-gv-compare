#!/usr/bin/env bash
java -cp serializer-2.7.2.jar:slf4j-jdk14.jar:tibcrypt.jar:xalan-2.7.2.jar:xml-apis-1.3.04.jar org.apache.xalan.xslt.Process -IN "$1" -XSL table.xsl -OUT "$2"
