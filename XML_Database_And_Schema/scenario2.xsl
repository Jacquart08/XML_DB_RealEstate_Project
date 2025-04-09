<?xml version="1.0" encoding="UTF-8"?>
<!-- 
  XSLT Stylesheet for Real Estate Advertisement Campaign  
  Purpose: Transform property data into structured advertisements.
  Team Actions:
    - Fixed path issues to correctly map XML data.
    - Removed references to non-existent fields.
    - Added meaningful output for available data.
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- We set the output format to XML with indentation for readability -->
  <xsl:output method="xml" indent="yes"/>

  <!-- 
    MAIN TEMPLATE
    We start processing from the root element of the XML database.
  -->
  <xsl:template match="/RealEstate_Database">
    <!-- We create the wrapper element for all advertisements -->
    <AdvertisementCampaign>
      
      <!-- 
        PROPERTY LOOP
        We iterate through each Property under Properties.
        Original issue: Previously used 'Properties' directly, missing the nested 'Property' element.
        Fix: Changed to 'Properties/Property' to access individual properties.
      -->
      <xsl:for-each select="Properties/Property">
        <!-- We store the current property's ID for reference -->
        <xsl:variable name="propertyID" select="PropertyID" />
        
        <!-- 
          LANDLORD LOOKUP
          We find the landlord associated with this property.
          Original issue: Path didn't account for nested Landlord element.
          Fix: Added '/Landlord' to the path.
        -->
        <xsl:variable name="landlord" 
                     select="/RealEstate_Database/LandLordInformations/Landlord[PropertyID = $propertyID]" />
        
        <!-- 
          AGENT LOOKUP
          We find the agent handling this property.
          Original issue: Same path problem as landlord lookup.
          Fix: Added '/Agent' to the path.
        -->
        <xsl:variable name="agent" 
                     select="/RealEstate_Database/RealEstateAgent/Agent[PropertyID = $propertyID]" />

        <!-- We create the advertisement block for this property -->
        <Ad>
          <!-- We output the property ID -->
          <PropertyID><xsl:value-of select="$propertyID"/></PropertyID>
          
          <!-- 
            PROPERTY DESCRIPTION
            We create a descriptive text using the property's city.
            Improvement: Directly uses the property's City instead of landlord's city.
          -->
          <Description>
            <xsl:value-of select="concat('Beautiful property located in ', City, ', ready for sale. Contact us for more details!')"/>
          </Description>

          <!-- 
            LANDLORD SECTION
            We display landlord information.
            Original issue: Tried to show non-existent Phone/Email fields.
            Decision: Removed those fields and added the complete address instead.
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
            AGENT SECTION
            We display agent information.
            Original issue: Tried to show non-existent Phone/Email fields.
            Decision: Kept only the available SIRET information.
          -->
          <Agent>
            <FullName>
              <xsl:value-of select="concat($agent/AgentFirstName, ' ', $agent/AgentName)"/>
            </FullName>
            <AgencySIRET><xsl:value-of select="$agent/AgencySIRET"/></AgencySIRET>
          </Agent>

          <!-- 
            CALL TO ACTION
            We include a standard call-to-action message.
            Note: This is static text that appears in all advertisements.
          -->
          <AdAction>Contact us now to schedule a viewing or inquire more details about the property!</AdAction>
        </Ad>
      </xsl:for-each>
    </AdvertisementCampaign>
  </xsl:template>
</xsl:stylesheet>
