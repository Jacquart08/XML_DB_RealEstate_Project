<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  XSL Stylesheet for Finding Closest Notary / Identify the most suitable notary for a property sale based on location

-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/RealEstate_Database">
    <NotaryRecommendation>
      <!-- Getting the property we're working with -->
      <xsl:variable name="property" select="Properties/Property[1]"/>
      
      <!-- Storing property location details -->
      <xsl:variable name="propertyCity" select="$property/City"/>
      <xsl:variable name="propertyZIP" select="$property/ZIPCode"/>
      
      <Property>
        <PropertyID><xsl:value-of select="$property/PropertyID"/></PropertyID>
        <Address>
          <xsl:value-of select="concat($property/Address, ', ', $property/City, ' ', $property/ZIPCode)"/>
        </Address>
      </Property>
      
      <!-- Finding notaries in the same city -->
      <EligibleNotaries>
        <xsl:for-each select="NotaryInformations/Notary[NotaryCity = $propertyCity]">
          <xsl:sort select="abs(NotaryZIPcode - $propertyZIP)" data-type="number"/>
          <xsl:sort select="NotaryPercentage" data-type="number"/>
          
          <Notary>
            <NotaryID><xsl:value-of select="NotaryID"/></NotaryID>
            <Name>
              <xsl:value-of select="concat(NotaryFirstName, ' ', NotaryName)"/>
            </Name>
            <Address>
              <xsl:value-of select="concat(NotaryAddress, ', ', NotaryCity, ' ', NotaryZIPcode)"/>
            </Address>
            <ZIPDistance>
              <xsl:value-of select="abs(NotaryZIPcode - $propertyZIP)"/>
            </ZIPDistance>
            <NotaryPercentage>
              <xsl:value-of select="NotaryPercentage"/>
            </NotaryPercentage>
            <NotarySIRET><xsl:value-of select="NotarySIRET"/></NotarySIRET>
          </Notary>
        </xsl:for-each>
      </EligibleNotaries>
      
      <!-- Recommending the best notary (first in the sorted list) -->
      <RecommendedNotary>
        <xsl:variable name="bestNotary" select="NotaryInformations/Notary[NotaryCity = $propertyCity][1]"/>
        <NotaryID><xsl:value-of select="$bestNotary/NotaryID"/></NotaryID>
        <Name>
          <xsl:value-of select="concat($bestNotary/NotaryFirstName, ' ', $bestNotary/NotaryName)"/>
        </Name>
        <Distance>
          <xsl:value-of select="abs($bestNotary/NotaryZIPcode - $propertyZIP)"/> (ZIP code difference)
        </Distance>
        <NotaryPercentage>
          <xsl:value-of select="$bestNotary/NotaryPercentage"/>%
        </NotaryPercentage>
      </RecommendedNotary>
    </NotaryRecommendation>
  </xsl:template>
</xsl:stylesheet>
