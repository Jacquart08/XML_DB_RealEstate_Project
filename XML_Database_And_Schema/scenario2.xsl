<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  For Real Estate Advertisement Campaign  
  Transforming the property data into structured advertisements.

-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- We set the output format to XML with indentation for readability -->
  <xsl:output method="xml" indent="yes"/>

  <!-- 
    We start processing from the root element of the XML database.
  -->
  <xsl:template match="/RealEstate_Database">
    <!-- We create the wrapper element for all advertisements -->
    <AdvertisementCampaign>
      
      <!-- 
        PROPERTY LOOP
        We iterate through each Property under Properties.
        Original issue: Previously used 'Properties' directly, missing the nested 'Property' element.
      -->
      <xsl:for-each select="Properties/Property">
        <!-- We store the current property's ID for reference -->
        <xsl:variable name="propertyID" select="PropertyID" />
        
        <!-- 
          We find the landlord associated with this property.
        -->
        <xsl:variable name="landlord" 
                     select="/RealEstate_Database/LandLordInformations/Landlord[PropertyID = $propertyID]" />
        
        <!-- 
          We find the agent handling this property.
        -->
        <xsl:variable name="agent" 
                     select="/RealEstate_Database/RealEstateAgent/Agent[PropertyID = $propertyID]" />

        <!-- We create the advertisement block for this property -->
        <Ad>
          <!-- We output the property ID -->
          <PropertyID><xsl:value-of select="$propertyID"/></PropertyID>
          
          <!-- 
            We create a descriptive text using the property's city.
          -->
          <Description>
            <xsl:value-of select="concat('Beautiful property located in ', City, ', ready for sale. Contact us for more details!')"/>
          </Description>

          <!-- 
            We display landlord information.
          -->
          <Landlord>
            <FullName>
              <xsl:value-of select="concat($landlord/LandlordFirstName, ' ', $landlord/LandlordName)"/>
            </FullName>
            <Address>
              <xsl:value-of select="concat($landlord/LandlordAddress, ', ', $landlord/LandlordCity, ' ', $landlord/LandlordZIPcode)"/>
            </Address>
          </Landlord>

          <!-- 
            We display agent information.
   
          -->
          <Agent>
            <FullName>
              <xsl:value-of select="concat($agent/AgentFirstName, ' ', $agent/AgentName)"/>
            </FullName>
            <AgencySIRET><xsl:value-of select="$agent/AgencySIRET"/></AgencySIRET>
          </Agent>

          <!-- 
            Note: This is static text that appears in all advertisements.
          -->
          <AdAction>Contact us now to schedule a viewing or inquire more details about the property!</AdAction>
        </Ad>
      </xsl:for-each>
    </AdvertisementCampaign>
  </xsl:template>
</xsl:stylesheet>
