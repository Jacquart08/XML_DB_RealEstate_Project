<?xml version="1.0" encoding="UTF-8"?>
<!-- Declare the XSLT version and namespace -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Realstate agent is looking to run an advertising campaign / web ads format  -->
  <xsl:output method="xml" indent="yes"/>

  <!-- Start the template processing from the root node of the XML -->
  <xsl:template match="/RealEstate_Database">
    
    <!-- Start the AdvertisementCampaign wrapper element to enclose all ad data -->
    <AdvertisementCampaign>

      <!-- Loop through each property listed in the RealEstate_Database -->
      <xsl:for-each select="Properties">

        <!-- Store the PropertyID of the current property in a variable -->
        <xsl:variable name="propertyID" select="PropertyID" />

        <!-- Locate the landlord who owns this property using PropertyID -->
        <!-- This will find the landlord associated with the current property -->
        <xsl:variable name="landlord" select="/RealEstate_Database/LandLordInformations[PropertyID = $propertyID]" />
        
        <!-- Locate the agent associated with this property using PropertyID -->
        <!-- This will find the real estate agent associated with the current property -->
        <xsl:variable name="agent" select="/RealEstate_Database/RealEstateAgent[PropertyID = $propertyID]" />

        <!-- Start the advertisement block for this property -->
        <Ad>

          <!-- Output the property ID involved in this advertisement -->
          <PropertyID><xsl:value-of select="$propertyID"/></PropertyID>

          <!-- Output the property description -->
          <!-- This description combines the location of the property (city) and a general message about it -->
          <Description>
            <xsl:value-of select="concat('Beautiful property located in ', $landlord/LandlordCity, ', ready for sale. Contact us for more details!')"/>
          </Description>

          <!-- Start a block to display the landlord's contact information -->
          <Landlord>
            <!-- Combine the landlord's first and last name to create a full name -->
            <FullName>
              <xsl:value-of select="concat($landlord/LandlordFirstName, ' ', $landlord/LandlordName)"/>
            </FullName>
            <!-- Display landlord's phone number and email -->
            <Phone><xsl:value-of select="$landlord/LandlordPhone"/></Phone>
            <Email><xsl:value-of select="$landlord/LandlordEmail"/></Email>
          </Landlord>

          <!-- Start a block to display the agent's contact information -->
          <Agent>
            <!-- Combine the agent's first and last name to create a full name -->
            <FullName>
              <xsl:value-of select="concat($agent/AgentFirstName, ' ', $agent/AgentName)"/>
            </FullName>
            <!-- Display agent's phone number and email -->
            <Phone><xsl:value-of select="$agent/AgentPhone"/></Phone>
            <Email><xsl:value-of select="$agent/AgentEmail"/></Email>
            <!-- Include the agency's SIRET number for reference -->
            <AgencySIRET><xsl:value-of select="$agent/AgencySIRET"/></AgencySIRET>
          </Agent>

          <!-- Action message for the advertisement -->
          <!-- A call to action encouraging potential buyers to contact the agency -->
          <AdAction>Contact us now to schedule a viewing or inquire more details about the property!</AdAction>

        </Ad>
      </xsl:for-each>

    </AdvertisementCampaign>
  </xsl:template>

</xsl:stylesheet>